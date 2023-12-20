import 'package:e3tmed/logic/interfaces/support.dart';

class IHelpImplementation implements ISupport {
  @override
  Future<bool> makeSupportRequest(
      String? name, String? email, String? message) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (name == "admin") {
      return true;
    } else {
      return false;
    }
  }
}
