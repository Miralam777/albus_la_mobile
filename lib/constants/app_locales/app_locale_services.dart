import 'package:albus_la_mobile/constants/app_locales/models/pdf/keychain_pdf_locale_model.dart';
import 'package:albus_la_mobile/constants/app_locales/models/pdf/pdf_locale_model.dart';

import 'models/app_locale_model.dart';
import 'models/language_model.dart';
import 'models/call_locale_model.dart';
import 'models/pdf/car_label_pdf_locale_model.dart';
import 'models/pdf/card_pdf_locale_model.dart';

class AppLocaleServices {
  AppLocaleServices._();

  static AppLocaleModel getLocaleByLangCode(String? langCode) {
    if ((langCode ?? '').isEmpty) return appLocales[1]; // en;

    for (int i = 0; i < appLocales.length; i++) {
      if (appLocales[i].locale == langCode) {
        return appLocales[i];
      }
    }

    return appLocales[1]; // en
  }

  static String getTranslatedLanguageName(
    LanguageModel model,
    String selectedLangCode,
  ) {
    switch (selectedLangCode) {
      case 'de':
        return model.de;
      case 'en':
        return model.en;
      case 'es':
        return model.es;
      case 'fr':
        return model.fr;
      case 'tr':
        return model.tr;
      case 'hi':
        return model.hi;
      case 'ar':
        return model.ar;
      default:
        return model.en;
    }
  }

  static List<AppLocaleModel> appLocales = [
    AppLocaleModel(
      locale: 'de',
      langOrginal: 'Deutsch',
      languageModel: LanguageModel(
        de: 'Deutsch',
        en: 'German',
        es: 'Alemán',
        fr: 'Allemand',
        tr: 'Almanca',
        hi: 'जर्मन',
        ar: 'ألمانية',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'Annehmen',
        declineText: 'Ablehnen',
        missedCallSubtitle: 'Verpasster Anruf',
        missedCallCallbackText: 'Zurückrufen',
        callingSubtitle: 'Ruft an...',
        callingCallbackText: 'Auflegen',
      ),
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'de',
          contactTitle: 'KFZ-HALTER',
          contactTitleFontSize: 16.2,
          // contactTitleFontSize: 20.0,
          contactSubtitle: 'KONTAKTIEREN',
          contactSubtitleFontSize: 13.5,
          // contactSubtitleFontSize: 16.6,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'de',
          contactTitle: 'INHABER KONTAKTIEREN',
          contactTitleFontSize: 15.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'de',
          contactTitle: 'INHABER KONTAKTIEREN',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
    AppLocaleModel(
      locale: 'en',
      langOrginal: 'English',
      languageModel: LanguageModel(
        de: 'Englisch',
        en: 'English',
        es: 'Inglés',
        fr: 'Anglais',
        tr: 'İngilizce',
        hi: 'अंग्रेज़ी',
        ar: 'إنجليزي',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'Accept',
        declineText: 'Decline',
        missedCallSubtitle: 'Missed call',
        missedCallCallbackText: 'Call back',
        callingSubtitle: 'Calling...',
        callingCallbackText: 'Hang Up',
      ),
      // TODO:
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'en',
          contactTitle: 'CONTACT',
          contactTitleFontSize: 15,
          contactSubtitle: 'OWNER',
          contactSubtitleFontSize: 17.0,
          contactSubtitleLetterSpacing: 2.5,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'en',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 13.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'en',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
    AppLocaleModel(
      locale: 'es',
      langOrginal: 'Español',
      languageModel: LanguageModel(
        de: 'Spanisch',
        en: 'Spanish',
        es: 'Español',
        fr: 'Espagnol',
        tr: 'İspanyolca',
        hi: 'स्पेनी',
        ar: 'إسباني',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'Aceptar',
        declineText: 'Rechazar',
        missedCallSubtitle: 'Llamada perdida',
        missedCallCallbackText: 'Devolver la llamada',
        callingSubtitle: 'Llamando...',
        callingCallbackText: 'Colgar',
      ),
      // TODO:
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'es',
          contactTitle: 'CONTACT',
          contactTitleFontSize: 15,
          contactSubtitle: 'OWNER',
          contactSubtitleFontSize: 17.0,
          contactSubtitleLetterSpacing: 2.5,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'es',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 13.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'es',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
    AppLocaleModel(
      locale: 'fr',
      langOrginal: 'Français',
      languageModel: LanguageModel(
        de: 'Französisch',
        en: 'French',
        es: 'Francés',
        fr: 'Français',
        tr: 'Fransızca',
        hi: 'फ़्रांसीसी',
        ar: 'فرنسي',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'Accepter',
        declineText: 'Refuser',
        missedCallSubtitle: 'Appel manqué',
        missedCallCallbackText: 'Rappeler',
        callingSubtitle: 'Appel...',
        callingCallbackText: 'Raccrocher',
      ),
      // TODO:
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'fr',
          contactTitle: 'CONTACT',
          contactTitleFontSize: 15,
          contactSubtitle: 'OWNER',
          contactSubtitleFontSize: 17.0,
          contactSubtitleLetterSpacing: 2.5,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'fr',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 13.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'fr',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
    AppLocaleModel(
      locale: 'it',
      langOrginal: 'Italiano',
      languageModel: LanguageModel(
        de: 'Italienisch',
        en: 'Italian',
        es: 'Italiano',
        fr: 'Italien',
        tr: 'İtalyanca',
        hi: 'इतालवी',
        ar: 'إيطالي',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'Accetta',
        declineText: 'Rifiuta',
        missedCallSubtitle: 'Chiamata persa',
        missedCallCallbackText: 'Richiama',
        callingSubtitle: 'Chiamata in corso...',
        callingCallbackText: 'Riaggancia',
      ),
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'it',
          contactTitle: 'CONTACT',
          contactTitleFontSize: 15,
          contactSubtitle: 'OWNER',
          contactSubtitleFontSize: 17.0,
          contactSubtitleLetterSpacing: 2.5,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'it',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 13.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'it',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
    AppLocaleModel(
      locale: 'tr',
      langOrginal: 'Türkçe',
      languageModel: LanguageModel(
        de: 'Türkisch',
        en: 'Turkish',
        es: 'Turco',
        fr: 'Turc',
        tr: 'Türkçe',
        hi: 'तुर्की',
        ar: 'تركي',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'Kabul et',
        declineText: 'Reddet',
        missedCallSubtitle: 'Cevapsız çağrı',
        missedCallCallbackText: 'Geri ara',
        callingSubtitle: 'Aranıyor...',
        callingCallbackText: 'Kapat',
      ),
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'tr',
          contactTitle: 'CONTACT',
          contactTitleFontSize: 15,
          contactSubtitle: 'OWNER',
          contactSubtitleFontSize: 17.0,
          contactSubtitleLetterSpacing: 2.5,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'tr',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 13.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'tr',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
    AppLocaleModel(
      locale: 'hi',
      langOrginal: 'हिन्दी',
      languageModel: LanguageModel(
        de: 'Hindi',
        en: 'Hindi',
        es: 'Hindi',
        fr: 'Hindi',
        tr: 'Hintçe',
        hi: 'हिन्दी',
        ar: 'هندي',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'स्वीकार करें',
        declineText: 'अस्वीकार करें',
        missedCallSubtitle: 'मिस्ड कॉल',
        missedCallCallbackText: 'वापस कॉल करें',
        callingSubtitle: 'कॉल हो रही है...',
        callingCallbackText: 'कॉल काटें',
      ),
      // TODO:
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'hi',
          contactTitle: 'CONTACT',
          contactTitleFontSize: 15,
          contactSubtitle: 'OWNER',
          contactSubtitleFontSize: 17.0,
          contactSubtitleLetterSpacing: 2.5,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'hi',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 13.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'hi',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
    AppLocaleModel(
      locale: 'ar',
      langOrginal: 'العربية',
      languageModel: LanguageModel(
        de: 'Arabisch',
        en: 'Arabic',
        es: 'Árabe',
        fr: 'Arabe',
        tr: 'Arapça',
        hi: 'अरबी',
        ar: 'العربية',
      ),
      callLocaleModel: CallLocaleModel(
        acceptText: 'قبول',
        declineText: 'رفض',
        missedCallSubtitle: 'مكالمة فائتة',
        missedCallCallbackText: 'إعادة الاتصال',
        callingSubtitle: 'جارٍ الاتصال...',
        callingCallbackText: 'إنهاء المكالمة',
      ),
      // TODO:
      pdfLocaleModel: PdfLocaleModel(
        carLabel: CarLabelPdfLocaleModel(
          locale: 'ar',
          contactTitle: 'CONTACT',
          contactTitleFontSize: 15,
          contactSubtitle: 'OWNER',
          contactSubtitleFontSize: 17.0,
          contactSubtitleLetterSpacing: 2.5,
        ),
        // TODO:
        keychain: KeychainPdfLocaleModel(
          locale: 'ar',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 13.0,
        ),
        // TODO:
        card: CardPdfLocaleModel(
          locale: 'ar',
          contactTitle: 'Contact Owner',
          contactTitleFontSize: 20.0,
        ),
      ),
    ),
  ];
}
