import 'dart:typed_data';

import 'package:flutter/material.dart';

class ExtraPhotoWidget extends StatelessWidget {
  final Uint8List imageData;
  final void Function(Uint8List imageData)? removeImage;
  final void Function(Uint8List imageData) previewImage;
  final bool? isRemovable;
  final double? imageSize;

  const ExtraPhotoWidget(
      {Key? key,
      required this.imageData,
      this.removeImage,
      required this.previewImage,
      this.isRemovable,
      this.imageSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => previewImage(imageData),
      child: Row(
        children: [
          Stack(alignment: Alignment.topRight, children: [
            Image.memory(
              imageData,
              height: imageSize ?? 100,
              width: imageSize ?? 100,
              fit: BoxFit.fill,
            ),
            isRemovable ?? false
                ? InkWell(
                    onTap: () => isRemovable! ? removeImage!(imageData) : null,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        Icons.close_sharp,
                        color: Colors.red[900],
                        size: 28,
                      ),
                    ),
                  )
                : const SizedBox(),
          ]),
          const SizedBox(
            width: 1,
          )
        ],
      ),
    );
  }
}
