import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/common/dropdownmenu/field_drop_down_menu.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../logic/interfaces/IStrings.dart';
import '../buttons/primarybuttonshape.dart';
import '../buttons/secondarybuttonshape.dart';

class CustomAddressDialogWidget extends StatefulWidget {
  final List<String> countryList;
  final List<String> cityList;
  final List<String> regionList;
  final UserAddress? userAddress;
  final void Function(UserAddress) onSaveChanges;

  const CustomAddressDialogWidget(
      {Key? key,
      required this.countryList,
      required this.cityList,
      required this.regionList,
      required this.onSaveChanges,
      this.userAddress})
      : super(key: key);

  @override
  State<CustomAddressDialogWidget> createState() =>
      _CustomAddressDialogWidgetState();
}

class _CustomAddressDialogWidgetState extends State<CustomAddressDialogWidget> {
  late UserAddress userAddress;
  final strings = Injector.appInstance.get<IStrings>();

  @override
  void initState() {
    super.initState();
    if (widget.userAddress == null) {
      userAddress = UserAddress(
          id: 0,
          isPrimary: true,
          country: "",
          city: "",
          region: "",
          address: "");
    } else {
      userAddress = widget.userAddress!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Text(
                strings.getStrings(AllStrings.addressTitle),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20),
              ),
              const Divider(
                thickness: 0.7,
              ),
              const SizedBox(
                height: 10,
              ),
              FieldDropDownMenu(
                hintText: strings.getStrings(AllStrings.countryTitle),
                items: widget.countryList,
                initialValue:
                    userAddress.country == "" ? null : userAddress.country,
                onChanged: (index, value) => setState(() {
                  userAddress.country = value ?? "";
                }),
              ),
              FieldDropDownMenu(
                  hintText: strings.getStrings(AllStrings.cityTitle),
                  initialValue:
                      userAddress.city == "" ? null : userAddress.city,
                  items: widget.cityList,
                  onChanged: (index, value) => setState(() {
                        userAddress.city = value ?? "";
                      })),
              FieldDropDownMenu(
                  hintText: strings.getStrings(AllStrings.regionTitle),
                  initialValue:
                      userAddress.region == "" ? null : userAddress.region,
                  items: widget.regionList,
                  onChanged: (index, value) => setState(() {
                        userAddress.region = value ?? "";
                      })),
              PrimaryTextFieldWithHeader(
                inputType: InputType.address,
                hintText: strings.getStrings(AllStrings.addressTitle),
                initialValue: userAddress.address,
                isRequired: true,
                isObscure: false,
                onChangedValue: (value) {
                  setState(() {
                    userAddress.address = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PrimaryButtonShape(
                        width: 150,
                        text: strings.getStrings(AllStrings.changeTitle),
                        color: Theme.of(context).primaryColor,
                        stream: null,
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onSaveChanges(userAddress);
                        }),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: SecondaryButtonShape(
                        width: 150,
                        text: strings.getStrings(AllStrings.cancelTitle),
                        color: Theme.of(context).colorScheme.secondary,
                        stream: null,
                        clickable: true,
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
