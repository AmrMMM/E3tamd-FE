import 'package:flutter/material.dart';

import '../main_loading.dart';

class SecondaryIconButtonShape extends StatelessWidget {
  final void Function() onTap;
  final IconData? iconData;
  final double width;
  final double? height;
  final double? textSize;
  final Color? backGroundColor;
  final String text;
  final Color color;
  final bool? clickable;
  final Stream<bool?>? stream;

  const SecondaryIconButtonShape(
      {Key? key,
      required this.width,
      this.iconData,
      this.height,
      required this.text,
      this.textSize,
      this.backGroundColor,
      required this.color,
      required this.stream,
      required this.onTap,
      this.clickable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: clickable != null && clickable! ? onTap : null,
        enableFeedback: true,
        child: Container(
          height: height ?? 45,
          width: width,
          decoration: BoxDecoration(
              color: backGroundColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color:
                      clickable != null && clickable! ? color : Colors.grey)),
          child: StreamBuilder<bool?>(
              stream: stream,
              builder: (context, snapshot) {
                return snapshot.data != true
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (iconData != null)
                            Icon(
                              iconData,
                              color: clickable != null && clickable!
                                  ? color
                                  : Colors.grey,
                            ),
                          TextButton(
                              onPressed: null,
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: clickable != null && clickable!
                                      ? color
                                      : Colors.grey,
                                  fontSize: textSize ?? 14,
                                ),
                              )),
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
    );
  }
}
