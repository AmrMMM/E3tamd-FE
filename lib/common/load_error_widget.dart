import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../logic/interfaces/IStrings.dart';

/// Shown when a load finally fails (transport retries exhausted) instead of an
/// endless spinner. Mirrors the error style used by the notifications screen.
class LoadErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const LoadErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final strings = Injector.appInstance.get<IStrings>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_outlined, size: 45, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            strings.getStrings(AllStrings.couldNotLoadDataTitle),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(strings.getStrings(AllStrings.retryTitle)),
          ),
        ],
      ),
    );
  }
}
