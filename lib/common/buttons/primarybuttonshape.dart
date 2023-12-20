import 'package:flutter/material.dart';

import '../main_loading.dart';

class PrimaryButtonShape extends StatelessWidget {
  final void Function() onTap;
  final double width;
  final double? height;
  final double? radius;
  final String text;
  final Color color;
  final Stream<bool?>? stream;
  final bool? clickable;
  final IconData? icon;
  final String? imageAsset;

  const PrimaryButtonShape(
      {Key? key,
      required this.width,
      this.height,
      required this.text,
      required this.color,
      this.stream,
      required this.onTap,
      this.radius,
      this.clickable,
      this.icon,
      this.imageAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: height ?? 45,
        width: width,
        decoration: BoxDecoration(
          color: clickable ?? false ? Colors.grey : color,
          borderRadius: BorderRadius.circular(radius ?? 6.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: clickable ?? false ? null : onTap,
            borderRadius: BorderRadius.circular(radius ?? 6.0),
            child: StreamBuilder<bool?>(
                stream: stream,
                builder: (context, snapshot) {
                  return snapshot.data != true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon != null)
                              Icon(
                                icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            if ((imageAsset ?? "").isNotEmpty)
                              Image.asset(
                                "assets/$imageAsset",
                                width: 30,
                                height: 30,
                                color: Colors.white,
                              ),
                            Text(
                              text,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                }),
          ),
        ),
      ),
    );
  }
}
