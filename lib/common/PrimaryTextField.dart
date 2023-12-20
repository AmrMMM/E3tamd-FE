import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final String label;
  final TextDirection valueDirection;
  final TextDirection labelDirection;
  final void Function(String) onChanged;
  final bool isPassword;
  final String? value;
  final bool enabled;

  const PrimaryTextField(
      {Key? key,
      required this.label,
      this.valueDirection = TextDirection.rtl,
      this.labelDirection = TextDirection.rtl,
      this.isPassword = false,
      this.value,
      this.enabled = true,
      required this.onChanged})
      : super(key: key);

  @override
  PrimaryTextFieldState createState() => PrimaryTextFieldState();
}

class PrimaryTextFieldState extends State<PrimaryTextField> {
  bool isTextRevealed = false;
  TextEditingController controller = TextEditingController();

  void setTextValue() {
    if (widget.value != null) {
      bool bigChange =
          (widget.value!.length - controller.text.length).abs() > 1;
      controller.value = TextEditingValue(
        text: widget.value!,
        selection: TextSelection.fromPosition(
          TextPosition(
              offset: bigChange
                  ? -1
                  : controller.selection.base.offset -
                      (widget.value!.length < controller.text.length ? 1 : 0)),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant PrimaryTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && controller.text != widget.value!) {
      setTextValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(5));
    var disabledBorder = border.copyWith(
        borderSide: border.borderSide.copyWith(color: Colors.white38));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
      child: Directionality(
        textDirection: widget.labelDirection,
        child: TextField(
            enabled: widget.enabled,
            controller: controller,
            obscureText: widget.isPassword && !isTextRevealed,
            enableSuggestions: !widget.isPassword,
            autocorrect: !widget.isPassword,
            onChanged: (val) {
              widget.onChanged(val);
              //setTextValue();
            },
            textDirection: widget.valueDirection,
            style: const TextStyle(
                color: Colors.white, decorationColor: Colors.white),
            decoration: InputDecoration(
              suffixIcon: !widget.isPassword
                  ? null
                  : IconButton(
                      onPressed: () => setState(() {
                        isTextRevealed = !isTextRevealed;
                      }),
                      icon: Icon(
                          isTextRevealed
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white),
                    ),
              labelText: widget.label,
              hintTextDirection: TextDirection.rtl,
              fillColor: Colors.white,
              focusColor: Colors.white,
              labelStyle: const TextStyle(
                  color: Colors.white, fontFamily: "Jenine", fontSize: 21),
              disabledBorder: disabledBorder,
              enabledBorder: border,
              focusedBorder: border,
            )),
      ),
    );
  }
}
