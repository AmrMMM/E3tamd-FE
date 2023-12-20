import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DefaultFloatingActionButton.dart';
import 'FilledTextField.dart';

class DefaultSearchAppBar extends StatelessWidget {
  final Widget child;
  final void Function(String) onTextChanged;

  const DefaultSearchAppBar(
      {Key? key, required this.child, required this.onTextChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FilledTextField(onTextChanged: onTextChanged),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(child: child),
      floatingActionButton: const DefaultFloatingActionButton(),
    );
  }
}
