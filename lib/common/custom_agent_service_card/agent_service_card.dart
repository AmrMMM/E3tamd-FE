import 'package:e3tmed/models/agent_category.dart';
import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../image_widgets/category_image.dart';

class AgentCategoryWidget extends StatelessWidget {
  final AgentCategory category;
  final String title;
  final IconData iconData;
  final void Function() onTap;

  const AgentCategoryWidget(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.category,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black45,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(iconData, size: 50, color: Colors.white),
                  ),
                ),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AgentServiceWidget extends StatelessWidget {
  final Category category;
  final String title;
  final void Function() onTap;

  const AgentServiceWidget(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black45,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryImage(
                        category: category,
                        width: 50,
                        height: 50,
                        color: Colors.white),
                  ),
                ),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
