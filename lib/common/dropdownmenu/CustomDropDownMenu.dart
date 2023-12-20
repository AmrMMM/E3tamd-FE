import 'package:flutter/material.dart';

class CustomDropDownMenuItem extends StatelessWidget {
  final String assetImage;
  final String language;

  // final void Function() onTap;

  const CustomDropDownMenuItem({
    Key? key,
    required this.assetImage,
    required this.language,
    // required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/$assetImage'),
            ),
          ),
        ],
      ),
    );
  }
}
