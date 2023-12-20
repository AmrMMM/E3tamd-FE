import 'package:e3tmed/common/image_widgets/category_image.dart';
import 'package:e3tmed/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceButtonWidget extends StatelessWidget {
  final Category category;
  final String title;
  final void Function() onTap;

  const ServiceButtonWidget(
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
        elevation: 7,
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(
                  width: 20,
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
