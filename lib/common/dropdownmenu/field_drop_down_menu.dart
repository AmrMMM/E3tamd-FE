import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../logic/interfaces/IStrings.dart';

class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if ((other as Pair<F, S>).first != first) {
      return false;
    }
    return (other).second == second;
  }
}

class FieldDropDownMenu extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? initialValue;
  final String? fixedValue;
  final bool? isRequired;
  final void Function(int index, String? value) onChanged;

  const FieldDropDownMenu(
      {Key? key,
      required this.hintText,
      required this.items,
      required this.onChanged,
      this.isRequired,
      this.fixedValue,
      this.initialValue})
      : super(key: key);

  @override
  State<FieldDropDownMenu> createState() => _FieldDropDownMenuState();
}

class _FieldDropDownMenuState extends State<FieldDropDownMenu> {
  final IStrings _strings = Injector.appInstance.get<IStrings>();
  Pair<int, String>? selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedValue = Pair(
          widget.items.indexOf(widget.initialValue!), widget.initialValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.hintText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.isRequired ?? true)
                    const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: DropdownButtonFormField<Pair<int, String>>(
              value: selectedValue,
              hint: Text(
                widget.fixedValue != null && widget.fixedValue!.isNotEmpty
                    ? widget.fixedValue!
                    :
                '${_strings.getStrings(AllStrings.enterTitle)} ${widget.hintText}',
                style: const TextStyle(fontSize: 15),
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    color: Colors.brown,
                  ),
                ),
              ),
              onChanged: (choice) {
                setState(() {
                  selectedValue = choice;
                });
                widget.onChanged(choice!.first, choice.second);
              },
              validator: (value) {
                if (widget.fixedValue == null && value == null) {
                  return "Please chose a ${widget.hintText}";
                } else {
                  return null;
                }
              },
              items: widget.items
                  .asMap()
                  .entries
                  .map((item) => DropdownMenuItem<Pair<int, String>>(
                        value: Pair(item.key, item.value),
                        child: Text(item.value),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
