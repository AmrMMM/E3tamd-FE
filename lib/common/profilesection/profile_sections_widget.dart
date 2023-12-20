import 'package:flutter/material.dart';

class ProfileSectionWidget extends StatelessWidget {
  final String label;
  final IconData iconData;
  final void Function() onTap;

  const ProfileSectionWidget(
      {Key? key,
      required this.label,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: null,
                      icon: Icon(
                        iconData,
                        size: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        label,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  Icon(
                    Icons.arrow_right,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            height: 0.8,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
