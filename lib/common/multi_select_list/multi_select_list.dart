import 'package:e3tmed/screens/agent_phase/order/additional_custom_widgets/order_details_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../logic/interfaces/IStrings.dart';
import '../buttons/primarybuttonshape.dart';

class MultiSelectList<T> extends StatefulWidget {
  final List<T> items;
  final void Function(List<T> models) selectedItems;
  final String Function(T model) titleSelector;
  final double Function(T model) priceSelector;
  final Widget Function(T model)? imageSelector;

  const MultiSelectList(
      {super.key,
      required this.items,
      required this.selectedItems,
      required this.titleSelector,
      required this.priceSelector,
      this.imageSelector});

  @override
  MultiSelectListState<T> createState() => MultiSelectListState<T>();
}

class MultiSelectListState<T> extends State<MultiSelectList<T>> {
  final strings = Injector.appInstance.get<IStrings>();
  final selectedExtrasList = <T>[];

  // Keep track of selected items
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  title: PartsAndExtrasWidget(
                    itemName: widget.titleSelector(widget.items[index]),
                    itemPrice: widget.priceSelector(widget.items[index]),
                    image: widget.imageSelector == null
                        ? null
                        : widget.imageSelector!(widget.items[index]),
                  ),
                  value: selectedExtrasList.contains(widget.items[index]),
                  onChanged: (value) => setState(() {
                    {
                      if (selectedExtrasList.contains(widget.items[index])) {
                        selectedExtrasList.remove(widget.items[index]);
                      } else {
                        selectedExtrasList.add(widget.items[index]);
                      }
                    }
                  }),
                );
              },
            ),
          ),
          PrimaryButtonShape(
              width: double.infinity,
              text: strings.getStrings(AllStrings.confirmTitle),
              color: Theme.of(context).colorScheme.secondary,
              stream: null,
              onTap: () {
                Navigator.of(context).pop();
                widget.selectedItems(selectedExtrasList);
              }),
        ],
      ),
    );
  }
}
