import 'package:e3tmed/logic/interfaces/IConfiguration.dart';
import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:injector/injector.dart';

class Configuration implements IConfiguration {
  final http = Injector.appInstance.get<IHTTP>();

  @override
  Future<String> getCurrentVersion() async {
    var res = await http.rget("Configuration/Version");
    if (res.statusCode == 200 && res.rawBody != null) {
      return res.rawBody;
    }
    return "";
  }
}
