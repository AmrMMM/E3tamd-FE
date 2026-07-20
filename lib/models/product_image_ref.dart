import 'package:e3tmed/models/IModelFactory.dart';

/// One image in a product's gallery. Carries the inline preview used for the thumbnail strip plus
/// the id the full-size image is fetched by - never the full-size bytes themselves.
class ProductImageRef implements IJsonSerializable {
  int id;

  /// Inline preview (a `data:` URI). Null when the image has no thumbnail generated yet.
  String? thumbnail;

  ProductImageRef({required this.id, this.thumbnail});

  @override
  Map<String, dynamic> toJson() => {"id": id, "thumbnail": thumbnail};
}

class ProductImageRefFactory implements IModelFactory<ProductImageRef> {
  @override
  ProductImageRef fromJson(Map<String, dynamic> jsonMap) {
    return ProductImageRef(
        id: jsonMap["id"], thumbnail: jsonMap["thumbnail"]);
  }
}
