import 'package:flutter/material.dart';

import '../dropdownmenu/CustomDropDownMenu.dart';

class MainLanguageFilter extends StatelessWidget {
  final String languageImage;
  final void Function(Object? value) onChanged;

  const MainLanguageFilter(
      {Key? key, required this.languageImage, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        icon: SizedBox(
            width: 20, height: 20, child: Image.asset('assets/$languageImage')),
        items: const [
          DropdownMenuItem(
            value: "english.png",
            child: CustomDropDownMenuItem(
              assetImage: 'english.png',
              language: 'english',
            ),
          ),
          DropdownMenuItem(
            value: 'arabic.png',
            child: CustomDropDownMenuItem(
              assetImage: 'arabic.png',
              language: 'العربية',
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
