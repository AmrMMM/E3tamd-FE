import 'dart:typed_data';

import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../main_loading.dart';

class HTTPImage extends StatefulWidget {
  final String endpoint;
  final Map<String, dynamic>? queryArgs;
  final dynamic body;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final Color? loadingColor;
  final BorderRadius? borderRadius;

  const HTTPImage(this.endpoint,
      {Key? key,
      this.queryArgs,
      this.body,
      this.width,
      this.height,
      this.color,
      this.fit,
      this.borderRadius,
      this.loadingColor})
      : super(key: key);

  @override
  HTTPImageState createState() => HTTPImageState();
}

class HTTPImageState extends State<HTTPImage> {
  final http = Injector.appInstance.get<IHTTP>();
  Uint8List? data;
  double? progress;
  bool disposed = false;
  bool errored = false;

  void loadImage() async {
    var imgData = await http.getBytes(widget.endpoint,
        queryArgs: widget.queryArgs,
        body: widget.body, progress: (newProgress) {
      if (disposed) {
        return;
      }
      if (newProgress >= 0.2) {
        setState(() {
          progress = newProgress;
        });
      }
    });
    if (disposed) {
      return;
    }
    if (imgData == null) {
      setState(() {
        errored = true;
      });
    } else {
      setState(() {
        data = imgData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  @override
  Widget build(BuildContext context) {
    return errored
        ? SizedBox(width: widget.width, height: widget.height)
        : data == null
            ? const Center(child: MainLoadinIndicatorWidget())
            : Material(
                borderRadius: widget.borderRadius,
                color: Colors.transparent,
                child: Image.memory(
                  filterQuality: FilterQuality.high,
                  data!,
                  width: widget.width,
                  height: widget.height,
                  color: widget.color,
                  fit: widget.fit,
                ),
              );
  }
}
