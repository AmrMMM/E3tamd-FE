import 'package:flutter/material.dart';
import 'package:e3tmed/common/DefaultFloatingActionButton.dart';
import 'package:flutter/services.dart';

class DefaultAppBarScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final bool useDefaultFab;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const DefaultAppBarScaffold(
      {super.key,
      required this.title,
      required this.child,
      this.useDefaultFab = false,
      this.backgroundColor,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headline3),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: actions,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(child: child),
      floatingActionButton:
          useDefaultFab ? const DefaultFloatingActionButton() : null,
    );
  }
}
