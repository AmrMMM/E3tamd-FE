import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/logic/interfaces/support.dart';
import 'package:injector/injector.dart';

class Support implements ISupport {
  final http = Injector.appInstance.get<IHTTP>();

  @override
  Future<bool> makeSupportRequest(
      String name, String email, String message) async {
    final res = await http.post("Support",
        body: {"name": name, "email": email, "message": message});
    return (res.statusCode == 200);
  }
}
