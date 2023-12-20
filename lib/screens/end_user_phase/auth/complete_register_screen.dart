// ignore_for_file: unused_field

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/dropdownmenu/field_drop_down_menu.dart';
import 'package:e3tmed/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/buttons/primarybuttonshape.dart';
import '../../../common/customalertdialog/custom_alert_dialog.dart';
import '../../../common/customtextfield/CustomTextField.dart';
import '../../../logic/interfaces/IAuth.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/complete_register_viewmodel.dart';
import '../../../viewmodels/end_user_viewmodels/register_screen_viewmodel.dart';

class CompleteRegisterScreen extends ScreenWidget {
  CompleteRegisterScreen(BuildContext context) : super(context);

  @override
  CompleteRegisterScreenState createState() =>
      // ignore: no_logic_in_create_state
      CompleteRegisterScreenState(context);
}

class CompleteRegisterScreenState
    extends BaseStateObject<CompleteRegisterScreen, CompleteRegisterViewModel> {
  CompleteRegisterScreenState(BuildContext context)
      : super(() => CompleteRegisterViewModel(context));

  final IStrings _strings = Injector.appInstance.get<IStrings>();

  final location = Location();
  List<Country> countyList = [];
  List<City> cityList = [];
  List<Region> regionList = [];
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: prefer_final_fields
  String _language = "english.png";

  String _firstName = "";
  String _lastName = "";
  String _country = "Saudi arabia";
  String _city = "Riyadh";
  String _region = "Region 1";
  String _address = "";

  @override
  void initState() {
    super.initState();
    countyList = location.countries ?? [];
    cityList = location.cities ?? [];
    regionList = location.regions ?? [];
    viewModel.isRegisteredErrd.listen((event) {
      if (event != null) {
        showDialog(
            barrierDismissible: true,
            useSafeArea: false,
            context: context,
            builder: (context) => Dialog(
                  child: CustomAlertDialogWidget(
                      aknowledgeOnly: true,
                      title: _strings.getStrings(AllStrings.loginTitle),
                      description: event,
                      onPositivePressed: () => Navigator.of(context).pop()),
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RegisterScreenArgs;
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView(children: [
                Image.asset(
                  'assets/logo_colored.png',
                  width: 250,
                  height: 250,
                ),
                // StreamBuilder<String?>(
                //   stream: viewModel.isRegisteredErrd,
                //   builder: (context, snapshot) {
                //     return snapshot.data != null
                //         ? Center(
                //             child: Text(
                //               snapshot.data!,
                //               style: const TextStyle(
                //                   color: Colors.red,
                //                   fontWeight: FontWeight.bold),
                //             ),
                //           )
                //         : const SizedBox();
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _strings.getStrings(AllStrings.createNewAccountTitle),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      Container(),
                    ],
                  ),
                ),
                PrimaryTextFieldWithHeader(
                  inputType: InputType.name,
                  hintText: _strings.getStrings(AllStrings.firstNameTitle),
                  isObscure: false,
                  isRequired: true,
                  onChangedValue: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  },
                ),
                PrimaryTextFieldWithHeader(
                  inputType: InputType.name,
                  hintText: _strings.getStrings(AllStrings.lastNameTitle),
                  isRequired: true,
                  isObscure: false,
                  onChangedValue: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  },
                ),
                FieldDropDownMenu(
                  hintText: _strings.getStrings(AllStrings.countryTitle),
                  items: countyList.map((e) => e.getCountryName()).toList(),
                  fixedValue: _country,
                  onChanged: (index, value) {
                    setState(() {
                      _country = value!;
                    });
                  },
                ),
                FieldDropDownMenu(
                  hintText: _strings.getStrings(AllStrings.cityTitle),
                  items: cityList.map((e) => e.getCityName()).toList(),
                  fixedValue: _city,
                  onChanged: (index, value) {
                    setState(() {
                      _city = value!;
                    });
                  },
                ),
                FieldDropDownMenu(
                  hintText: _strings.getStrings(AllStrings.regionTitle),
                  items: regionList.map((e) => e.getRegionName()).toList(),
                  fixedValue: _region,
                  onChanged: (index, value) {
                    setState(() {
                      _region = value!;
                    });
                  },
                ),
                PrimaryTextFieldWithHeader(
                  inputType: InputType.address,
                  hintText: _strings.getStrings(AllStrings.addressTitle),
                  isObscure: false,
                  isRequired: true,
                  onChangedValue: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                ),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: _strings.getStrings(AllStrings.registerTitle),
                    color: Theme.of(context).primaryColor,
                    stream: viewModel.loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        viewModel.registerAccountWithCompleteArgs(
                            CompleteRegisterArgs(
                                firstName: _firstName,
                                lastName: _lastName,
                                email: args.email,
                                password: args.password,
                                phone: args.phone,
                                country: _country,
                                city: _city,
                                region: _region,
                                address: _address));
                      }
                    }),
              ]),
            ),
          )),
    );
  }
}
