import 'call_locale_model.dart';
import 'language_model.dart';
import 'pdf/pdf_locale_model.dart';

class AppLocaleModel {
  final String locale;
  final String langOrginal;
  final LanguageModel languageModel;
  // TODO: remove callLocaleModel
  final CallLocaleModel callLocaleModel;
  final PdfLocaleModel pdfLocaleModel;

  AppLocaleModel({
    required this.locale,
    required this.langOrginal,
    required this.languageModel,
    required this.callLocaleModel,
    required this.pdfLocaleModel,
  });
}
