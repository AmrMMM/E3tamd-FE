import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/models/user_auth_model.dart';

enum LoginState { unAuthenticated, user, agent }

enum AuthMode { email, phoneNumber }

const currentAuthenticationMode = AuthMode.phoneNumber;

abstract class IAuth {
  Future<bool> login(String username, String password);

  Future<RegistrationResult> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String phone,
    String country,
    String city,
    String region,
    String address,
  );

  Future<bool> verifyUsername(String code, bool isRegister);

  LoginState? isLoggedIn();

  Future<bool> logOut();

  Future<bool> updatePassword(String currentPassword, String newPassword);

  Future<bool> updateFirstAndLastName(String firstName, String lastName);

  Future<bool> updateEmail(String newEmail);

  Future<bool> updatePhoneNumber(String newPhoneNumber);

  Future<List<UserAddress>> getUserAddresses();

  Future<bool> insertNewAddress(UserAddress address);

  Future<bool> updateAddress(UserAddress address);

  Future<bool> deleteAddress(UserAddress address);

  Future<bool> forgetPassword(String username);

  Future<bool> continueForgetPassword(String code, String newPassword);

  Future<String> getAccessToken();

  Stream<LoginState?> get loggedInStream;

  Stream<UserAuthModel?> get authData;
}
