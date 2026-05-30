import 'car_label_pdf_locale_model.dart';
import 'card_pdf_locale_model.dart';
import 'keychain_pdf_locale_model.dart';

class PdfLocaleModel {
  // final String locale;
  final CarLabelPdfLocaleModel carLabel;
  final KeychainPdfLocaleModel keychain;
  final CardPdfLocaleModel card;

  PdfLocaleModel({
    // required this.locale,
    required this.carLabel,
    required this.keychain,
    required this.card,
  });
}
