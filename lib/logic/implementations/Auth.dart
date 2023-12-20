// ignore_for_file: file_names

import 'package:async/async.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/models/AuthModels.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends IAuth {
  final _loggedInController = BehaviorSubject<LoginState?>.seeded(null);
  final _userData = BehaviorSubject<UserAuthModel?>.seeded(null);
  final IHTTP http = Injector.appInstance.get<IHTTP>();

  CancelableOperation? tokenRenewal;
  String? registerUsername;
  UserAuthModel? lastAuthData;

  bool? isAgent;
  bool notificationsInitialized = false;

  Auth() {
    _autoLogin();
  }

  bool _processToken(BackendResultWithBody<LoginResult> res) {
    LoginResult body = res.body![0];
    http.setJWToken(body.token);
    _userData.add(UserAuthModel(
        name: "${body.firstName} ${(body.lastName ?? " ")}",
        email: body.email,
        phone: body.phoneNumber,
        imageUrl: "https://cdn-icons-png.flaticon.com/512/149/149071.png",
        token: body.token,
        address: body.address,
        region: body.region,
        city: body.city,
        country: body.country,
        userId: body.userId,
        firstName: body.firstName,
        lastName: body.lastName));
    tokenRenewal = CancelableOperation.fromFuture(Future.delayed(
        Duration(minutes: body.expiresIn - 1), () => _tokenRefresh()));
    isAgent = body.role == "Agent";
    if (_loggedInController.value == LoginState.unAuthenticated) {
      _loggedInController.add(isAgent! ? LoginState.agent : LoginState.user);
    }
    if (isAgent!) {
      Injector.appInstance.get<INotificationsManager>().initialize(body.token);
    }
    return true;
  }

  void _tokenRefresh() async {
    var res = await http.rpost<LoginResult>('Account/RefreshToken');
    if (res.statusCode != 200) {
      if (!_loggedInController.hasValue ||
          _loggedInController.value != LoginState.unAuthenticated) {
        _loggedInController.add(LoginState.unAuthenticated);
      }
      return;
    }
    isAgent = res.body![0].role == "Agent";
    if (!_loggedInController.hasValue ||
        _loggedInController.value == null ||
        _loggedInController.value == LoginState.unAuthenticated) {
      _loggedInController.add(isAgent! ? LoginState.agent : LoginState.user);
    }
    _processToken(res);
  }

  void _autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    final userAuthToken = pref.getString("token");
    if ((userAuthToken?.length ?? 0) > 0) {
      http.setJWToken(userAuthToken!);
      _tokenRefresh();
    } else {
      _loggedInController.add(LoginState.unAuthenticated);
    }
  }

  @override
  Future<bool> login(String username, String password) async {
    final pref = await SharedPreferences.getInstance();
    var res = await http.rpost<LoginResult>('Account/Token', body: {
      "username": username,
      "password": password,
    });
    if (res.statusCode == 400 || res.statusCode == 404) {
      return false;
    }
    pref.setString("token", res.body![0].token);
    return _processToken(res);
  }

  @override
  LoginState? isLoggedIn() => _loggedInController.value;

  @override
  Future<bool> logOut() async {
    final pref = await SharedPreferences.getInstance();
    if (tokenRenewal != null) {
      tokenRenewal!.cancel();
      tokenRenewal = null;
    }
    await http.post('Account/Logout');
    http.setJWToken("");
    _userData.add(null);
    _loggedInController.add(LoginState.unAuthenticated);
    pref.setString("token", "");
    return true;
  }

  @override
  Future<RegistrationResult> register(
      String firstName,
      String lastName,
      String email,
      String password,
      String phone,
      String country,
      String city,
      String region,
      String address) async {
    var res = await http.rpost("Account/Register", body: {
      "firstName": firstName,
      "lastName": lastName,
      "country": country,
      "city": city,
      "region": region,
      "address": address,
      "phoneNumber": phone,
      "email": email,
      "password": password,
      "username": currentAuthenticationMode == AuthMode.email ? email : phone
    });
    if (res.statusCode == 200) {
      registerUsername =
          currentAuthenticationMode == AuthMode.email ? email : phone;
      await login(phone, password);
      return RegistrationResult(
          success: true, phoneConflict: false, emailConflict: false);
    } else if (res.statusCode == 409) {
      return RegistrationResult(
          success: false,
          phoneConflict: res.rawBody["phoneNumber"],
          emailConflict: res.rawBody["email"]);
    }
    return RegistrationResult(
        success: false, phoneConflict: false, emailConflict: false);
  }

  @override
  Future<bool> verifyUsername(String code, bool isRegister) async {
    var res = await http.post(
        isRegister ? "Account/Register/FollowUp" : "Account/Username/Verify",
        body: {"username": registerUsername, "code": code});
    if (res.statusCode == 200) {
      if (!isRegister) {
        var data = _userData.value!;
        if (currentAuthenticationMode == AuthMode.email) {
          data.email = registerUsername;
        } else {
          data.phone = registerUsername;
        }
        _userData.add(data);
      }
      registerUsername = null;
      return true;
    }
    return false;
  }

  @override
  Stream<LoginState?> get loggedInStream => _loggedInController.stream;

  @override
  Stream<UserAuthModel?> get authData => _userData.stream;

  updateAuthData() async {}

  @override
  Future<List<UserAddress>> getUserAddresses() async {
    final res = await http.rpost<UserAddress>("UserAddress/GetAll");
    if (res.statusCode == 200) {
      return res.body ?? [];
    }
    return [];
  }

  @override
  Future<bool> insertNewAddress(UserAddress address) async {
    final res = await http.post("UserAddress/Insert", body: address);
    if (res.statusCode == 201) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateAddress(UserAddress address) async {
    final res = await http.put("UserAddress/Update",
        queryArgs: {"Id": address.id}, body: address);
    if (res.statusCode == 202) {
      var data = _userData.value!;
      data.address = "$address";
      _userData.add(data);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteAddress(UserAddress address) async {
    final res = await http.delete("UserAddress/Delete",
        queryArgs: {"Id": address.id, "IsHard": false});
    if (res.statusCode == 202) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateFirstAndLastName(String firstName, String lastName) async {
    final res = await http.put("Account/Data", body: {
      "firstName": firstName,
      "lastName": lastName,
      "country": _userData.value!.country,
      "city": _userData.value!.city,
      "region": _userData.value!.region,
      "address": _userData.value!.address
    });
    if (res.statusCode == 200) {
      var data = _userData.value!;
      data.name = "$firstName $lastName";
      _userData.add(data);
      return true;
    }
    return false;
  }

  @override
  Future<bool> updatePassword(
      String currentPassword, String newPassword) async {
    final res = await http.put("Account/Password",
        body: {"oldValue": currentPassword, "newValue": newPassword});
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateEmail(String newEmail) async {
    final res =
        await http.put("Account/Email", queryArgs: {"newEmail": newEmail});
    if (res.statusCode == 200) {
      if (currentAuthenticationMode == AuthMode.email) {
        registerUsername = newEmail;
      } else {
        var data = _userData.value!;
        data.email = newEmail;
        _userData.add(data);
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> updatePhoneNumber(String newPhoneNumber) async {
    final res = await http
        .put("Account/PhoneNumber", queryArgs: {"phoneNumber": newPhoneNumber});
    if (res.statusCode == 200) {
      if (currentAuthenticationMode == AuthMode.phoneNumber) {
        registerUsername = newPhoneNumber;
      } else {
        var data = _userData.value!;
        data.phone = newPhoneNumber;
        _userData.add(data);
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> forgetPassword(String username) async {
    final res = await http
        .post("Account/ForgetPassword", queryArgs: {"username": username});
    if (res.statusCode == 200) {
      registerUsername = username;
      return true;
    }
    return false;
  }

  @override
  Future<bool> continueForgetPassword(String code, String newPassword) async {
    final res = await http.post("Account/ContinueForgetPassword",
        queryArgs: {"username": registerUsername, "code": code},
        body: newPassword);
    if (res.statusCode == 200) {
      registerUsername = "";
      return true;
    }
    return false;
  }

  @override
  Future<String> getAccessToken() {
    return Future.value(_userData.value?.token ?? "");
  }
}
