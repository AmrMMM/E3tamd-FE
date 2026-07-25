// ignore_for_file: no_logic_in_create_state

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/main_loading.dart';
import 'package:e3tmed/common/markdown_body_view.dart';
import 'package:e3tmed/models/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/terms_and_conditions_view_model.dart';

class TermsAndConditionsScreen extends ScreenWidget {
  TermsAndConditionsScreen(BuildContext context) : super(context);

  @override
  TermsAndConditionsScreenState createState() =>
      TermsAndConditionsScreenState(context);
}

class TermsAndConditionsScreenState extends BaseStateObject<
    TermsAndConditionsScreen, TermsAndConditionsViewModel> {
  TermsAndConditionsScreenState(BuildContext context)
      : super(() => TermsAndConditionsViewModel(context));

  final strings = Injector.appInstance.get<IStrings>();
  late final Future<TermsAndConditions?> _future =
      viewModel.getTermsAndConditions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.termAndConditionsTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: FutureBuilder<TermsAndConditions?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: MainLoadinIndicatorWidget());
            }
            final text = snapshot.data?.getLocalized() ?? "";
            if (text.trim().isEmpty) {
              return Center(
                child: Text(
                  strings.getStrings(AllStrings.couldNotLoadDataTitle),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: MarkdownBodyView(data: text),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: PrimaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.agreeTitle),
                    color: Theme.of(context).colorScheme.secondary,
                    onTap: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
