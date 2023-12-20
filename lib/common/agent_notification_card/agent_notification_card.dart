import 'package:flutter/material.dart';

class AgentNotificationCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String dateTime;
  final void Function()? onTap;

  const AgentNotificationCardWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.dateTime,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(43, 162, 129, 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: 35,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Text(
                        dateTime,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
