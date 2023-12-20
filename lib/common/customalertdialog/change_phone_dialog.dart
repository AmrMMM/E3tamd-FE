import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../DI.dart';
import '../../logic/interfaces/IStrings.dart';

class ChangePhoneNumberDialog extends StatefulWidget {
  final String title;
  final String description;
  final void Function(String) onChangePressed;

  const ChangePhoneNumberDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.onChangePressed,
  }) : super(key: key);

  @override
  State<ChangePhoneNumberDialog> createState() =>
      _ChangePhoneNumberDialogState();
}

class _ChangePhoneNumberDialogState extends State<ChangePhoneNumberDialog> {
  String newPhoneNumber = "";
  final strings = Injector.appInstance.get<IStrings>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        ))
                  ],
                ),
                Text(
                  strings.getStrings(AllStrings.enterThePhoneNumberTitle),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                PrimaryTextFieldWithHeader(
                    isEditable: true,
                    isRequired: true,
                    fixedValue:
                        strings.getStrings(AllStrings.enterThePhoneNumberTitle),
                    isObscure: false,
                    onChangedValue: (value) {
                      newPhoneNumber = value;
                    },
                    inputType: InputType.phone),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.changeTitle),
                    color: Theme.of(context).colorScheme.secondary,
                    stream: null,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        widget.onChangePressed(newPhoneNumber);
                      }
                    }),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
