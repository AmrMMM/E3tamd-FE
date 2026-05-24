import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class GuestLoginCardWidget extends StatelessWidget {
  final VoidCallback onLoginTap;
  final VoidCallback? onRegisterTap;

  const GuestLoginCardWidget({
    Key? key,
    required this.onLoginTap,
    this.onRegisterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = Injector.appInstance.get<IStrings>();
    return Column(
      children: [
        Icon(
          Icons.person_outline,
          size: 48,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 12),
        Text(
          strings.getStrings(AllStrings.loginRequiredTitle),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onLoginTap,
                child: Text(strings.getStrings(AllStrings.loginTitle)),
              ),
            ),
            if (onRegisterTap != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRegisterTap,
                  child:
                      Text(strings.getStrings(AllStrings.registerNowTitle)),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 15),
        const Divider(
          height: 0.8,
          color: Colors.grey,
        ),
      ],
    );
  }
}
