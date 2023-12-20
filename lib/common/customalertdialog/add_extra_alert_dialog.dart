import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:flutter/material.dart';

class AddExtraAlertDialog extends StatefulWidget {
  final void Function(ExtraModel extrasModel) addExtras;
  final String headTitle;

  const AddExtraAlertDialog({
    Key? key,
    required this.headTitle,
    required this.addExtras,
  }) : super(key: key);

  @override
  State<AddExtraAlertDialog> createState() => _AddExtraAlertDialogState();
}

class _AddExtraAlertDialogState extends State<AddExtraAlertDialog> {
  String name = "";
  String price = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              "Enter ${widget.headTitle} Details",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            PrimaryTextFieldWithHeader(
                isEditable: true,
                fixedValue: widget.headTitle,
                isObscure: false,
                onChangedValue: (value) => setState(() {
                      name = value;
                    }),
                inputType: InputType.name),
            PrimaryTextFieldWithHeader(
                isEditable: true,
                fixedValue: "Price",
                isObscure: false,
                onChangedValue: (value) => setState(() {
                      price = value.toString();
                    }),
                inputType: InputType.number),
            PrimaryButtonShape(
                width: double.infinity,
                text: "Add",
                color: Theme.of(context).colorScheme.secondary,
                stream: null,
                onTap: () {
                  Navigator.of(context).pop();
                  widget.addExtras(ExtraModel(
                      id: 2,
                      price: double.parse(price),
                      stock: 5,
                      nameAr: name,
                      nameEn: name));
                }),
            const SizedBox(
              width: 3,
            ),
          ],
        ),
      ),
    );
  }
}
