import 'package:flutter/material.dart';

import '../main_loading.dart';

class SecondaryButtonShape extends StatelessWidget {
  final void Function() onTap;
  final double width;
  final double? height;
  final double? textSize;
  final String text;
  final Color color;
  final bool? clickable;
  final Stream<bool?>? stream;

  const SecondaryButtonShape(
      {Key? key,
      required this.width,
      this.height,
      required this.text,
      this.textSize,
      required this.color,
      required this.stream,
      required this.onTap,
      this.clickable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: height ?? 45,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
                color: clickable != null && clickable! ? color : Colors.grey)),
        child: StreamBuilder<bool?>(
            stream: stream,
            builder: (context, snapshot) {
              return snapshot.data != true
                  ? TextButton(
                      onPressed: clickable != null && clickable! ? onTap : null,
                      child: Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: clickable != null && clickable!
                              ? color
                              : Colors.grey,
                          fontSize: textSize ?? 14,
                        ),
                      ))
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
            }),
      ),
    );
  }
}
