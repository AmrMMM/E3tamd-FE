import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../buttons/secondarybuttonshape.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool? aknowledgeOnly;
  final void Function() onPositivePressed;

  const CustomAlertDialogWidget({
    Key? key,
    required this.title,
    required this.description,
    this.aknowledgeOnly,
    required this.onPositivePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final string = Injector.appInstance.get<IStrings>();
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: const TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
            const Divider(
              thickness: 0.7,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                description,
                style: TextStyle(color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PrimaryButtonShape(
                      width: aknowledgeOnly ?? false ? double.infinity : 75,
                      text: aknowledgeOnly ?? false
                          ? string.getStrings(AllStrings.confirmTitle)
                          : string.getStrings(AllStrings.yesTitle),
                      color: Colors.red,
                      stream: null,
                      onTap: onPositivePressed),
                ),
                SizedBox(
                  width: aknowledgeOnly ?? false ? 0 : 3,
                ),
                aknowledgeOnly ?? false
                    ? const SizedBox()
                    : Expanded(
                        child: SecondaryButtonShape(
                            width: 75,
                            text: string.getStrings(AllStrings.noTitle),
                            color: Theme.of(context).colorScheme.secondary,
                            clickable: true,
                            stream: null,
                            onTap: () => Navigator.of(context).pop()),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
