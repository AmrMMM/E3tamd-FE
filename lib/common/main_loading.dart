import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MainLoadinIndicatorWidget extends StatelessWidget {
  final Color? hasColor;
  final int? hasSize;

  const MainLoadinIndicatorWidget({super.key, this.hasColor, this.hasSize});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.threeRotatingDots(
      color: hasColor ?? Theme.of(context).primaryColor,
      size: hasSize?.toDouble() ?? 35,
    );
  }
}
