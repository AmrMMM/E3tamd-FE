import 'package:e3tmed/models/IModelFactory.dart';

class NotificationModel implements IJsonSerializable {
  final int id;
  final String? title;
  final String? description;
  final DateTime? dateTime;
  final int? serviceId;
  final int? categoryId;

  NotificationModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.dateTime,
      required this.serviceId,
      required this.categoryId});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "dateTime": dateTime,
      "serviceId": serviceId,
      "categoryId": categoryId
    };
  }
}

class NotificationModelFactory implements IModelFactory<NotificationModel> {
  @override
  NotificationModel fromJson(Map<String, dynamic> jsonMap) {
    return NotificationModel(
        id: jsonMap["id"],
        title: jsonMap["title"],
        description: jsonMap["description"],
        dateTime: jsonMap["dateTime"],
        serviceId: jsonMap["serviceId"],
        categoryId: jsonMap["categoryId"]);
  }
}
