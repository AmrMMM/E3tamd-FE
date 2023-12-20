// ignore_for_file: file_names

import 'package:e3tmed/DI.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../screens/end_user_phase/settings/settings_screen.dart';

enum InputType {
  name,
  email,
  password,
  phone,
  address,
  number,
  longText,
}

class PrimaryTextFieldWithHeader extends StatefulWidget {
  final bool isObscure;
  final String? hintText;
  final InputType inputType;
  final String? fixedValue;
  final String? initialValue;
  final String? labelText;
  final RegExp? validation;
  final bool? isEditable;
  final bool? isRequired;
  final int? maxChars;
  final void Function(String value) onChangedValue;

  const PrimaryTextFieldWithHeader(
      {Key? key,
      this.hintText,
      required this.isObscure,
      required this.onChangedValue,
      required this.inputType,
      this.isEditable,
      this.fixedValue,
      this.isRequired,
      this.initialValue,
      this.validation,
      this.labelText,
      this.maxChars})
      : super(key: key);

  @override
  State<PrimaryTextFieldWithHeader> createState() =>
      _PrimaryTextFieldWithHeaderState();
}

class PrefixItem {
  final String prefix;
  final String country;
  final String shortCode;
  final int numberOfDigits;

  const PrefixItem(
      {required this.prefix,
      required this.country,
      required this.shortCode,
      required this.numberOfDigits});
}

class _PrimaryTextFieldWithHeaderState
    extends State<PrimaryTextFieldWithHeader> {
  // final String? Function(String? value) validator;
  final IStrings strings = Injector.appInstance.get<IStrings>();
  late bool textVisibility;
  static const List<PrefixItem> phonePrefixes = [
    PrefixItem(
        prefix: "+966",
        country: "Saudi Arabia",
        shortCode: "SA",
        numberOfDigits: 9),
    PrefixItem(
        prefix: "+20", country: "Egypt", shortCode: "EG", numberOfDigits: 10)
  ];
  PrefixItem phonePrefix = phonePrefixes.first;
  String valueBuffer = "";

  @override
  void initState() {
    super.initState();
    textVisibility = widget.isObscure;
    valueBuffer = widget.initialValue ?? widget.fixedValue ?? "";
    valueBuffer =
        phonePrefixes.any((element) => valueBuffer.startsWith(element.prefix))
            ? valueBuffer.substring(phonePrefixes
                .firstWhere((element) => valueBuffer.startsWith(element.prefix))
                .prefix
                .length)
            : valueBuffer;
    if (widget.inputType == InputType.phone) {
      String query;
      if (widget.initialValue != null) {
        query = widget.initialValue!.trim();
      } else if (widget.fixedValue != null) {
        query = widget.fixedValue!.trim();
      } else {
        return;
      }
      phonePrefix = phonePrefixes.cast<PrefixItem?>().firstWhere(
              (element) => query.startsWith(element!.prefix),
              orElse: () => null) ??
          phonePrefixes.first;
    }
  }

  @override
  void didUpdateWidget(covariant PrimaryTextFieldWithHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inputType == InputType.phone) {
      String query;
      if (widget.initialValue != null) {
        query = widget.initialValue!.trim();
      } else if (widget.fixedValue != null) {
        query = widget.fixedValue!.trim();
      } else {
        return;
      }
      phonePrefix = phonePrefixes.cast<PrefixItem?>().firstWhere(
              (element) => query.startsWith(element!.prefix),
              orElse: () => null) ??
          phonePrefixes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          if (widget.hintText != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.labelText ?? widget.hintText,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    widget.isRequired != null && widget.isRequired!
                        ? const TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ))
                        : const TextSpan(text: ""),
                  ],
                ),
              ),
            ),
          Directionality(
              textDirection: widget.inputType == InputType.phone
                  ? TextDirection.ltr
                  : useLanguage == Languages.arabic.name
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.inputType == InputType.phone) ...[
                      Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: (widget.isEditable ?? true)
                                  ? Colors.black26
                                  : Colors.black12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton<PrefixItem>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(25),
                            items: !(widget.isEditable ?? true)
                                ? []
                                : phonePrefixes
                                    .map((e) => DropdownMenuItem<PrefixItem>(
                                          value: e,
                                          child: Text(
                                            "${e.country} (${e.prefix})".trim(),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                            selectedItemBuilder: (context) => phonePrefixes
                                .map((e) => DropdownMenuItem<PrefixItem>(
                                      value: e,
                                      child: Text(
                                        "${e.prefix} (${e.shortCode})".trim(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            hint: !(widget.isEditable ?? true)
                                ? Align(
                                    alignment:
                                        const AlignmentDirectional(-1.0, 0),
                                    child: Text(
                                        "${phonePrefix.prefix} (${phonePrefix.shortCode})"))
                                : const SizedBox(),
                            value: phonePrefix,
                            onChanged: (newVal) => setState(() {
                                  phonePrefix = newVal ?? phonePrefixes.first;
                                  widget.onChangedValue(
                                      phonePrefix.prefix + valueBuffer);
                                })),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                    Expanded(
                      child: TextFormField(
                        enabled: widget.isEditable,
                        textDirection: widget.inputType == InputType.phone ||
                                widget.inputType == InputType.number ||
                                widget.inputType == InputType.password
                            ? TextDirection.ltr
                            : useLanguage == Languages.arabic.name
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                        maxLines:
                            widget.inputType == InputType.longText ? 7 : 1,
                        obscureText: textVisibility,
                        maxLength: widget.inputType == InputType.name
                            ? widget.maxChars ?? 15
                            : widget.inputType == InputType.phone
                                ? phonePrefix.numberOfDigits
                                : null,
                        keyboardType: widget.inputType == InputType.phone ||
                                widget.inputType == InputType.number
                            ? TextInputType.number
                            : null,
                        initialValue: widget.inputType == InputType.phone &&
                                widget.initialValue != null &&
                                phonePrefixes.any((element) => widget
                                    .initialValue!
                                    .trim()
                                    .startsWith(element.prefix))
                            ? widget.initialValue!.substring(phonePrefixes
                                .firstWhere((element) => widget.initialValue!
                                    .startsWith(element.prefix))
                                .prefix
                                .length)
                            : widget.initialValue,
                        onChanged: (newVal) {
                          valueBuffer = newVal.trim();
                          if (widget.inputType == InputType.phone) {
                            widget.onChangedValue(
                                phonePrefix.prefix + newVal.trim());
                          } else {
                            widget.onChangedValue(newVal.trim());
                          }
                        },
                        validator: (value) {
                          if (widget.validation != null) {
                            if (value == null && (widget.isRequired ?? false)) {
                              return "${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                            }
                            return widget.validation!.hasMatch(value!)
                                ? null
                                : "${strings.getStrings(AllStrings.enterCorrectTitle)} ${widget.hintText}";
                          }
                          if (widget.isRequired != null && widget.isRequired!) {
                            if (widget.inputType == InputType.name) {
                              if (value!.trim().isEmpty) {
                                return " ${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                              } else if (!RegExp(r'[a-zA-Z\u0600-\u06FF]+$')
                                  .hasMatch(value.trim())) {
                                return "${strings.getStrings(AllStrings.enterCorrectTitle)} ${widget.hintText}";
                              } else {
                                return null;
                              }
                            } else if (widget.inputType == InputType.phone) {
                              if (value!.trim().isEmpty) {
                                return " ${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                              } else if (!RegExp(
                                      '^[1-9][0-9]{${phonePrefix.numberOfDigits - 1}}\$')
                                  .hasMatch(value.trim())) {
                                return "${strings.getStrings(AllStrings.enterCorrectTitle)} ${widget.hintText},${strings.getStrings(AllStrings.cannotStartWithZero)}";
                              } else {
                                return null;
                              }
                            } else if (widget.inputType == InputType.email) {
                              if (value!.trim().isEmpty) {
                                return " ${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                              } else if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value.trim())) {
                                return "${strings.getStrings(AllStrings.enterCorrectTitle)} ${widget.hintText}";
                              } else {
                                return null;
                              }
                            } else if (widget.inputType == InputType.password) {
                              if (value!.trim().isEmpty) {
                                return " ${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                              } else if (!RegExp(r'^.{8,}$')
                                  .hasMatch(value.trim())) {
                                return "${strings.getStrings(AllStrings.enterCorrectTitle)} ${widget.hintText}";
                              } else {
                                return null;
                              }
                            } else if (widget.inputType == InputType.number) {
                              if (value!.trim().isEmpty) {
                                return " ${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                              } else if (!RegExp(r'^\d+$')
                                  .hasMatch(value.trim())) {
                                return "${strings.getStrings(AllStrings.enterCorrectTitle)} ${widget.hintText}";
                              } else {
                                return null;
                              }
                            } else if (widget.inputType == InputType.address) {
                              if (value!.trim().isEmpty) {
                                return "${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                              } else {
                                return null;
                              }
                            } else if (widget.inputType == InputType.longText) {
                              if (value!.trim().isEmpty) {
                                return "${widget.hintText} ${strings.getStrings(AllStrings.isRequiredTitle)}";
                              } else {
                                return null;
                              }
                            } else {
                              return 'Un supported format';
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: widget.inputType == InputType.password
                              ? IconButton(
                                  icon: const Icon(Icons.visibility,
                                      color: Colors.grey),
                                  onPressed: () => setState(
                                    () {
                                      textVisibility = !textVisibility;
                                    },
                                  ),
                                )
                              : null,
                          contentPadding: const EdgeInsets.all(10),
                          hintText: widget.fixedValue != null &&
                                  widget.fixedValue!.isNotEmpty
                              ? widget.inputType == InputType.phone &&
                                      phonePrefixes.any((element) => widget
                                          .fixedValue!
                                          .startsWith(element.prefix))
                                  ? widget.fixedValue!.substring(phonePrefixes
                                      .firstWhere((element) => widget
                                          .fixedValue!
                                          .startsWith(element.prefix))
                                      .prefix
                                      .length)
                                  : widget.fixedValue
                              : '${strings.getStrings(AllStrings.enterTitle)} ${widget.hintText}',
                          hintStyle: const TextStyle(fontSize: 15),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Colors.brown,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
