// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:darq/darq.dart';
import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/models/IModelFactory.dart';
import 'package:injector/injector.dart';
import 'package:universal_io/io.dart';

class NetworkException implements Exception {
  final int statusCode;
  final dynamic body;

  NetworkException({required this.statusCode, required this.body});
}

class IOHTTP implements IHTTP {
  final String _baseUrl = "https://eatmed.cloud/api/";
  final Map<String, String> _headers = <String, String>{};

  // Transport guards: without these a stale mobile socket used to leave requests
  // pending forever (no timeout, no error path), which showed up as an infinite
  // spinner until the user backed out and retried on a fresh connection.
  static const int _maxAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  static const Duration _connectionTimeout = Duration(seconds: 8);
  static const Duration _requestTimeout = Duration(seconds: 20);
  static const Duration _streamStallTimeout = Duration(seconds: 15);

  // One shared client so keep-alive connections are actually reused. The old
  // code created a fresh HttpClient per request and never closed any of them.
  HttpClient? _client;

  HttpClient get _httpClient => _client ??= _makeClient();

  void log(String method, String endpoint, [Map<String, dynamic>? queryArgs]) {
    final url = _urlStringConstructor(endpoint, queryArgs);
    print("HTTP $method: $url");
  }

  HttpClient _makeClient() {
    final client = HttpClient();
    client.connectionTimeout = _connectionTimeout;
    client.badCertificateCallback = (a, b, c) => true;
    return client;
  }

  // Called when a request fails: drop the (possibly wedged) client so the next
  // attempt opens fresh connections. In-flight requests on the old client fail
  // fast and recover through their own retry.
  void _resetClient() {
    final old = _client;
    _client = null;
    old?.close(force: true);
  }

  String _urlStringConstructor(String endpoint,
      [Map<String, dynamic>? queryArgs]) {
    var url = _baseUrl + endpoint;
    if (queryArgs != null) {
      url +=
          "?${queryArgs.entries.map((e) => "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}").join('&')}";
    }
    return url;
  }

  Uri _urlConstructor(String endpoint, [Map<String, dynamic>? queryArgs]) {
    return Uri.parse(_urlStringConstructor(endpoint, queryArgs));
  }

  HttpClientRequest _injectHeaders(HttpClientRequest req) {
    req.headers.add("content-type", "application/json");
    for (var entry in _headers.entries) {
      req.headers.add(entry.key, entry.value);
    }
    return req;
  }

  HttpClientRequest _writeToBody(
      HttpClientRequest req, dynamic body, void Function(double)? progress) {
    if (body == null) return req;
    List<int> payload;
    if (body is IJsonSerializable) {
      payload = utf8.encode(jsonEncode(body.toJson()));
    } else if (body is List<IJsonSerializable>) {
      payload = utf8.encode(jsonEncode(body.map((e) => e.toJson()).toList()));
    } else {
      payload = utf8.encode(jsonEncode(body));
    }
    req.contentLength = payload.length;
    req.add(payload);
    return req;
  }

  // Both readers used to complete only in onDone: a mid-body connection error
  // or a frozen stream left the future pending forever. The stall timeout is
  // per-chunk, so a large-but-flowing download is fine while a silent socket
  // errors out after _streamStallTimeout of no data.
  Future<String> _readResponseAsString(
      HttpClientResponse response, void Function(double)? progress) {
    final completer = Completer<String>();
    final buffer = <int>[];
    response
        .timeout(_streamStallTimeout,
            onTimeout: (sink) =>
                sink.addError(TimeoutException("Response stream stalled")))
        .listen(
            (data) {
              buffer.addAll(data);
              if (response.contentLength != -1 && progress != null) {
                progress(buffer.length / response.contentLength);
              }
            },
            onDone: () => completer.complete(utf8.decode(buffer)),
            onError: completer.completeError,
            cancelOnError: true);
    return completer.future;
  }

  Future<Uint8List> _readResponseAsBytes(
      HttpClientResponse response, void Function(double)? progress) {
    final completer = Completer<Uint8List>();
    final buffer = <int>[];
    response
        .timeout(_streamStallTimeout,
            onTimeout: (sink) =>
                sink.addError(TimeoutException("Response stream stalled")))
        .listen(
            (data) {
              buffer.addAll(data);
              if (response.contentLength != -1 && progress != null) {
                progress(buffer.length / response.contentLength);
              }
            },
            onDone: () => completer.complete(Uint8List.fromList(buffer)),
            onError: completer.completeError,
            cancelOnError: true);
    return completer.future;
  }

  Future<Tuple2<List<T>?, dynamic>> _parseBodyOf<T extends IJsonSerializable>(
      HttpClientResponse response, void Function(double)? progress) async {
    dynamic resBody;
    String? bodyString;
    try {
      bodyString = await _readResponseAsString(response, progress);
      resBody = jsonDecode(bodyString);
      final responseFactory = Injector.appInstance.get<IModelFactory<T>>();
      List<T> result;
      if (resBody is List) {
        result = resBody.map((e) => responseFactory.fromJson(e)).toList();
      } else {
        result = [responseFactory.fromJson(resBody)];
      }
      return Tuple2(result, resBody);
    } catch (ex) {
      print("HTTP: failed to parse response body: $ex");
      return Tuple2(null, resBody);
    }
  }

  Future<HttpClientResponse> _processRequest(HttpClientRequest req,
      dynamic body, void Function(double)? progress) async {
    req = _injectHeaders(req);
    req = _writeToBody(req, body, progress);
    // The timeout turns a silently stalled request into a TimeoutException the
    // retry loop can act on, instead of an await that never returns.
    return await req.close().timeout(_requestTimeout);
  }

  Future<HttpClientResponse> _sendRequestHelper(
      HTTPRequestMethod method,
      String endpoint,
      Map<String, dynamic>? queryArgs,
      dynamic body,
      void Function(double)? progress) async {
    HttpClientRequest? req;
    switch (method) {
      case HTTPRequestMethod.GET:
        req = await _httpClient.getUrl(_urlConstructor(endpoint, queryArgs));
        break;
      case HTTPRequestMethod.POST:
        req = await _httpClient.postUrl(_urlConstructor(endpoint, queryArgs));
        break;
      case HTTPRequestMethod.PUT:
        req = await _httpClient.putUrl(_urlConstructor(endpoint, queryArgs));
        break;
      case HTTPRequestMethod.DELETE:
        req = await _httpClient.deleteUrl(_urlConstructor(endpoint, queryArgs));
        break;
    }
    return await _processRequest(req, body, progress);
  }

  // Retries used to be `while (true)` catching only SocketException: a stall
  // threw nothing (stuck forever) and a persistent failure retried forever.
  // Now every transport failure (IO or timeout) resets the shared client and is
  // retried a bounded number of times; the final failure escapes to the caller
  // so the UI can show an error instead of an eternal spinner.
  @override
  Future<BackendResultWithBody<O>>
      sendRequestWithResult<O extends IJsonSerializable>(
          HTTPRequestMethod method, String endpoint,
          {Map<String, dynamic>? queryArgs,
          dynamic body,
          void Function(double)? progress}) async {
    for (var attempt = 1;; attempt++) {
      try {
        final response = await _sendRequestHelper(
            method, endpoint, queryArgs, body, progress);
        final res = await _parseBodyOf<O>(response, progress);
        return BackendResultWithBody(
            statusCode: response.statusCode,
            body: res.item0,
            rawBody: res.item1);
      } on IOException {
        _resetClient();
        if (attempt >= _maxAttempts) rethrow;
      } on TimeoutException {
        _resetClient();
        if (attempt >= _maxAttempts) rethrow;
      }
      await Future.delayed(_retryDelay);
    }
  }

  @override
  Future<BackendResult> sendRequest(HTTPRequestMethod method, String endpoint,
      {Map<String, dynamic>? queryArgs,
      dynamic body,
      void Function(double)? progress}) async {
    for (var attempt = 1;; attempt++) {
      try {
        final response = await _sendRequestHelper(
            method, endpoint, queryArgs, body, progress);
        return BackendResult(statusCode: response.statusCode);
      } on IOException {
        _resetClient();
        if (attempt >= _maxAttempts) rethrow;
      } on TimeoutException {
        _resetClient();
        if (attempt >= _maxAttempts) rethrow;
      }
      await Future.delayed(_retryDelay);
    }
  }

  @override
  Future<Uint8List?> getBytes(String endpoint,
      {Map<String, dynamic>? queryArgs,
      dynamic body,
      void Function(double)? progress}) async {
    for (var attempt = 1;; attempt++) {
      try {
        final req =
            await _httpClient.getUrl(_urlConstructor(endpoint, queryArgs));
        final response = await _processRequest(req, body, progress);
        if (response.statusCode != 200) return null;
        return await _readResponseAsBytes(response, progress);
      } on IOException {
        _resetClient();
        // HTTPImage renders its error state for a null result, so the image
        // path degrades gracefully instead of throwing into the widget tree.
        if (attempt >= _maxAttempts) return null;
      } on TimeoutException {
        _resetClient();
        if (attempt >= _maxAttempts) return null;
      }
      await Future.delayed(_retryDelay);
    }
  }

  @override
  Future<BackendResult> delete(String endpoint,
      {Map<String, dynamic>? queryArgs, body}) {
    return sendRequest(HTTPRequestMethod.DELETE, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  Future<BackendResult> get(String endpoint,
      {Map<String, dynamic>? queryArgs, body}) {
    return sendRequest(HTTPRequestMethod.GET, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  Future<BackendResult> post(String endpoint,
      {Map<String, dynamic>? queryArgs, body}) {
    return sendRequest(HTTPRequestMethod.POST, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  Future<BackendResult> put(String endpoint,
      {Map<String, dynamic>? queryArgs, body}) {
    return sendRequest(HTTPRequestMethod.PUT, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  Future<BackendResultWithBody<O>> rdelete<O extends IJsonSerializable>(
      String endpoint,
      {Map<String, dynamic>? queryArgs,
      body,
      void Function(double)? progress}) {
    return sendRequestWithResult<O>(HTTPRequestMethod.DELETE, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  Future<BackendResultWithBody<O>> rget<O extends IJsonSerializable>(
      String endpoint,
      {Map<String, dynamic>? queryArgs,
      body,
      void Function(double)? progress}) {
    return sendRequestWithResult<O>(HTTPRequestMethod.GET, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  Future<BackendResultWithBody<O>> rpost<O extends IJsonSerializable>(
      String endpoint,
      {Map<String, dynamic>? queryArgs,
      body,
      void Function(double)? progress}) {
    return sendRequestWithResult<O>(HTTPRequestMethod.POST, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  Future<BackendResultWithBody<O>> rput<O extends IJsonSerializable>(
      String endpoint,
      {Map<String, dynamic>? queryArgs,
      body,
      void Function(double)? progress}) {
    return sendRequestWithResult<O>(HTTPRequestMethod.PUT, endpoint,
        queryArgs: queryArgs, body: body);
  }

  @override
  void setHeader(String key, String value) {
    _headers[key] = value;
  }

  @override
  void setJWToken(String token) {
    _headers["authorization"] = "Bearer $token";
  }
}
