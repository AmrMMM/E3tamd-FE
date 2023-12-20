import 'package:flutter/material.dart';

class QuantityCounter extends StatefulWidget {
  final int initialValue;
  final int max;
  final void Function(int quantity) onQuantityChange;

  const QuantityCounter(
      {super.key,
      this.initialValue = 1,
      required this.onQuantityChange,
      required this.max});

  @override
  QuantityCounterState createState() => QuantityCounterState();
}

class QuantityCounterState extends State<QuantityCounter> {
  late int _quantity;

  @override
  void initState() {
    _quantity = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: _quantity > 1 ? _decrementQuantity : null,
        ),
        Text(
          '$_quantity',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _quantity < widget.max ? _incrementQuantity : null,
        ),
      ],
    );
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      widget.onQuantityChange(_quantity);
    });
  }

  void _decrementQuantity() {
    setState(() {
      _quantity--;
      widget.onQuantityChange(_quantity);
    });
  }
}
