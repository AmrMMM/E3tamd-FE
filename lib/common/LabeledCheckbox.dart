import "package:flutter/material.dart";

class LabeledCheckbox extends StatelessWidget {
  final String? label;
  final void Function(bool?) onChange;
  final bool value;
  final bool enabled;
  final Color enabledColor;
  final Color disabledColor;
  final TextDirection direction;

  const LabeledCheckbox(
      {Key? key,
      this.enabled = true,
      required this.value,
      this.label,
      this.enabledColor = Colors.white,
      this.disabledColor = Colors.white38,
      this.direction = TextDirection.rtl,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dir =
        direction == TextDirection.rtl ? TextDirection.ltr : TextDirection.rtl;
    var color = MaterialStateColor.resolveWith(
        enabled ? (states) => enabledColor : (states) => disabledColor);
    return Directionality(
      textDirection: dir,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 0,
          children: [
            if (label != null)
              Transform.translate(
                  offset: const Offset(15, 0),
                  child: Text(
                    label!,
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
            AbsorbPointer(
              absorbing: !enabled,
              child: Checkbox(
                value: value,
                onChanged: onChange,
                fillColor: color,
                checkColor:
                    MaterialStateColor.resolveWith((states) => Colors.black),
                activeColor: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
