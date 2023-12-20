import 'package:flutter/material.dart';

class DefaultFloatingActionButton extends StatelessWidget {
  const DefaultFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/cart'),
      backgroundColor: Colors.yellow,
      child: const Icon(Icons.add_shopping_cart, color: Colors.black),
    );
  }
}
