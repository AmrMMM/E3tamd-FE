import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';

import '../DI.dart';

/// Terms & Conditions markdown in both languages, from GET
/// api/Configuration/TermsAndConditions. Mirrors how Product carries a bilingual
/// description and selects by the current language.
class TermsAndConditions implements IJsonSerializable {
  final String ar;
  final String en;

  TermsAndConditions({required this.ar, required this.en});

  /// The markdown for the active language, falling back to the other one if the
  /// preferred language has not been authored yet.
  String getLocalized() {
    final preferred = useLanguage == Languages.arabic.name ? ar : en;
    if (preferred.trim().isNotEmpty) return preferred;
    final fallback = useLanguage == Languages.arabic.name ? en : ar;
    return fallback;
  }

  @override
  Map<String, dynamic> toJson() => {"ar": ar, "en": en};
}

class TermsAndConditionsFactory implements IModelFactory<TermsAndConditions> {
  @override
  TermsAndConditions fromJson(Map<String, dynamic> jsonMap) {
    return TermsAndConditions(
      ar: jsonMap["ar"] ?? "",
      en: jsonMap["en"] ?? "",
    );
  }
}
