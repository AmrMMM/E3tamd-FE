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

  // Optional "add new" entry rendered at the top of the list. When tapped it runs
  // [onAddNew]; if that returns a new item, it is appended to the list and
  // pre-selected so the user can confirm it alongside the existing selections.
  final Future<T?> Function()? onAddNew;
  final String? addNewLabel;

  const MultiSelectList(
      {super.key,
      required this.items,
      required this.selectedItems,
      required this.titleSelector,
      required this.priceSelector,
      this.imageSelector,
      this.onAddNew,
      this.addNewLabel});

  @override
  MultiSelectListState<T> createState() => MultiSelectListState<T>();
}

class MultiSelectListState<T> extends State<MultiSelectList<T>> {
  final strings = Injector.appInstance.get<IStrings>();
  final selectedExtrasList = <T>[];
  late final List<T> items = [...widget.items];

  Future<void> _handleAddNew() async {
    final created = await widget.onAddNew!();
    if (created == null) return;
    setState(() {
      items.add(created);
      selectedExtrasList.add(created);
    });
  }

  // Keep track of selected items
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (widget.onAddNew != null) ...[
            InkWell(
              onTap: _handleAddNew,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Icon(Icons.add,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 25),
                    const SizedBox(width: 15),
                    Text(
                      widget.addNewLabel ?? "",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 0.7),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  title: PartsAndExtrasWidget(
                    itemName: widget.titleSelector(items[index]),
                    itemPrice: widget.priceSelector(items[index]),
                    image: widget.imageSelector == null
                        ? null
                        : widget.imageSelector!(items[index]),
                  ),
                  value: selectedExtrasList.contains(items[index]),
                  onChanged: (value) => setState(() {
                    {
                      if (selectedExtrasList.contains(items[index])) {
                        selectedExtrasList.remove(items[index]);
                      } else {
                        selectedExtrasList.add(items[index]);
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
