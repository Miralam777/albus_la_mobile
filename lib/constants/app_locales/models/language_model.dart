class LanguageModel {
  final String de;
  final String en;
  final String es;
  final String fr;
  final String tr;
  final String hi;
  final String ar;

  LanguageModel({
    required this.de,
    required this.en,
    required this.es,
    required this.fr,
    required this.tr,
    required this.hi,
    required this.ar,
  });

  String nameFor(String localeCode) {
    switch (localeCode) {
      case 'de':
        return de;
      case 'en':
        return en;
      case 'es':
        return es;
      case 'fr':
        return fr;
      case 'tr':
        return tr;
      case 'hi':
        return hi;
      case 'ar':
        return ar;
      default:
        // TODO:
        return en;
    }
  }
}
