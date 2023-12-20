import "package:flutter/material.dart";
import 'package:rxdart/rxdart.dart';

class ModalScreen extends StatefulWidget {
  final Widget child;
  final Widget modal;
  final bool isModalVisible;
  final void Function(bool) visibilityChanged;

  const ModalScreen(
      {super.key,
      required this.child,
      required this.modal,
      required this.isModalVisible,
      required this.visibilityChanged});

  @override
  ModalScreenState createState() => ModalScreenState();
}

class ModalScreenState extends State<ModalScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController modalSwitchController;
  late Animation<double> darkenAnimation;
  final modalVisibleStream = BehaviorSubject<bool>.seeded(false);
  final duration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    modalSwitchController =
        AnimationController(vsync: this, duration: duration);
    darkenAnimation = Tween<double>(begin: 0, end: 0.7).animate(CurvedAnimation(
        parent: modalSwitchController, curve: Curves.easeInOut));
    if (widget.isModalVisible) {
      showModal();
    }
  }

  @override
  void didUpdateWidget(covariant ModalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isModalVisible != oldWidget.isModalVisible) {
      if (widget.isModalVisible) {
        showModal(false);
      } else {
        hideModal(false);
      }
    }
  }

  void showModal([bool notify = true]) {
    modalVisibleStream.add(true);
    modalSwitchController.forward();
    if (notify) {
      widget.visibilityChanged(true);
    }
  }

  void hideModal([bool notify = true]) {
    modalVisibleStream.add(false);
    modalSwitchController.reverse();
    if (notify) {
      widget.visibilityChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedBuilder(
        animation: darkenAnimation,
        child: widget.child,
        builder: (context, child) => AbsorbPointer(
          absorbing: darkenAnimation.isCompleted,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                Color.fromRGBO(0, 0, 0, darkenAnimation.value),
                BlendMode.darken),
            child: child,
          ),
        ),
      ),
      AnimatedSwitcher(
          duration: duration,
          switchOutCurve: Curves.easeInOut,
          switchInCurve: Curves.easeInOut,
          child: StreamBuilder<bool>(
              stream: modalVisibleStream,
              builder: (context, snapshot) => (snapshot.data ?? false)
                  ? Stack(children: [
                      GestureDetector(
                          onTap: hideModal,
                          child: Container(color: Colors.transparent)),
                      widget.modal
                    ])
                  : const Center())),
    ]);
  }
}
