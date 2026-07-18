import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../logic/interfaces/IStrings.dart';

/// Shown when a list loads successfully but has no items, so an empty result
/// reads as "nothing here" instead of a blank screen. Mirrors the inline
/// empty-state style already used by the orders/offers/cart screens.
class EmptyStateWidget extends StatelessWidget {
  final String? message;
  final IconData icon;

  const EmptyStateWidget({super.key, this.message, this.icon = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) {
    final strings = Injector.appInstance.get<IStrings>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 40),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message ?? strings.getStrings(AllStrings.yourListIsEmptyTitle),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
