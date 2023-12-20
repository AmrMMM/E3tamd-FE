import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../../common/customtextfield/CustomTextField.dart';
import '../../../../logic/interfaces/IStrings.dart';

class EnterDimensionsManuallyWidget extends StatefulWidget {
  final void Function(String dimensions) returnDimensions;

  const EnterDimensionsManuallyWidget(
      {Key? key, required this.returnDimensions})
      : super(key: key);

  @override
  State<EnterDimensionsManuallyWidget> createState() =>
      _EnterDimensionsManuallyWidgetState();
}

class _EnterDimensionsManuallyWidgetState
    extends State<EnterDimensionsManuallyWidget> {
  final string = Injector.appInstance.get<IStrings>();
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PrimaryTextFieldWithHeader(
                isObscure: false,
                fixedValue: string.getStrings(AllStrings.heightTitle),
                onChangedValue: (value) {
                  setState(() {
                    height = double.parse(value);
                  });
                },
                inputType: InputType.number,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "X",
              ),
            ),
            Expanded(
                child: PrimaryTextFieldWithHeader(
              isObscure: false,
              fixedValue: string.getStrings(AllStrings.widthTitle),
              onChangedValue: (value) {
                width = double.parse(value);
              },
              inputType: InputType.number,
            )),
          ],
        ),
        PrimaryButtonShape(
            width: double.infinity,
            text: string.getStrings(AllStrings.confirmTitle),
            color: Theme.of(context).colorScheme.secondary,
            stream: null,
            onTap: () => widget.returnDimensions("${height}x$width CM"))
      ],
    );
  }
}
