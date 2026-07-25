import 'package:e3tmed/models/terms_and_conditions.dart';

abstract class IConfiguration {
  Future<String> getCurrentVersion();

  /// Fetches the Terms & Conditions markdown (both languages). Null on failure.
  Future<TermsAndConditions?> getTermsAndConditions();
}
