import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/models/IModelFactory.dart';

class APINotification implements IJsonSerializable {
  int id;
  NotificationType type;
  String body;
  Map<String, dynamic>? object;
  DateTime date;
  APINotification(
      {required this.id,
      required this.type,
      required this.date,
      this.body = "",
      this.object});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type.index,
        "body": body,
        "object": object,
        "date": date.toString()
      };
}

class APINotificationFactory implements IModelFactory<APINotification> {
  @override
  APINotification fromJson(Map<String, dynamic> jsonMap) {
    return APINotification(
        id: jsonMap["id"],
        type: NotificationType.values[jsonMap["type"]],
        date: DateTime.parse(jsonMap["date"]),
        body: jsonMap["body"] ?? "",
        object: jsonMap["object"]);
  }
}
