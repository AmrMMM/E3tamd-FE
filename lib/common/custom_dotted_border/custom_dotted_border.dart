import 'package:dotted_border/dotted_border.dart';
import 'package:e3tmed/DI.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class CustomDottedBorderWidget extends StatelessWidget {
  final String? message;

  const CustomDottedBorderWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: useLanguage == Languages.arabic.name
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: DottedBorder(
        radius: const Radius.circular(10),
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    message ?? "",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
