import 'package:e3tmed/DI.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../logic/interfaces/IStrings.dart';
import '../customalertdialog/custom_alert_dialog.dart';

class AddressCardWidget extends StatefulWidget {
  final UserAddress address;
  final bool? isSelectionAvailable;
  final void Function()? onTap;
  final void Function()? selected;
  final void Function(UserAddress)? onEdit;
  final void Function(UserAddress)? onDelete;

  const AddressCardWidget(
      {Key? key,
      required this.address,
      this.onEdit,
      this.onDelete,
      this.selected,
      this.onTap,
      this.isSelectionAvailable})
      : super(key: key);

  @override
  State<AddressCardWidget> createState() => _AddressCardWidgetState();
}

class _AddressCardWidgetState extends State<AddressCardWidget> {
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: useLanguage == Languages.arabic.name
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: widget.isSelectionAvailable != false &&
                  widget.isSelectionAvailable != null
              ? widget.onTap
              : widget.selected,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Text(
                    widget.address.address,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.address.country} ,${widget.address.city} ,${widget.address.region}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 15),
                      ),
                      const Expanded(child: SizedBox()),
                      // widget.isSelectionAvailable != false &&
                      //         widget.isSelectionAvailable != null
                      //     ? InkWell(
                      //         onTap: widget.onTap,
                      //         child: IgnorePointer(
                      //           child: Radio<bool>(
                      //               activeColor:
                      //                   Theme.of(context).colorScheme.secondary,
                      //               value: widget.address.isPrimary,
                      //               onChanged: (value) {},
                      //               groupValue: true),
                      //         ),
                      //       )
                      //     : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.address.isPrimary ? useLanguage == Languages.arabic.name?"الرئيسي":"Primary" : "",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 15),
                      ),
                      const Expanded(child: SizedBox()),
                      widget.isSelectionAvailable ?? false
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () => widget.onEdit!(widget.address),
                                  child: Text(
                                    strings.getStrings(AllStrings.editTitle),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                ),
                                if (!widget.address.isPrimary) ...[
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () => showPopUpDialog(context),
                                    child: Text(
                                      strings
                                          .getStrings(AllStrings.deleteTitle),
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 15),
                                    ),
                                  )
                                ]
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showPopUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: CustomAlertDialogWidget(
              title: strings.getStrings(AllStrings.deleteAddressTitle),
              description: strings.getStrings(
                  AllStrings.areYouSureYouWantToDeleteThisAddressTitle),
              onPositivePressed: () {
                Navigator.of(context).pop();
                widget.onDelete!(widget.address);
              },
            ),
          );
        });
  }
}
