class KeychainPdfLocaleModel {
  final String locale;
  final String contactTitle;
  final double contactTitleFontSize;
  final double contactTitleLetterSpacing;
  final String contactSubtitle;
  final double contactSubtitleFontSize;
  final double contactSubtitleLetterSpacing;

  KeychainPdfLocaleModel({
    required this.locale,
    required this.contactTitle,
    required this.contactTitleFontSize,
    this.contactTitleLetterSpacing = 0,
    required this.contactSubtitle,
    required this.contactSubtitleFontSize,
    this.contactSubtitleLetterSpacing = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'locale': locale,
      'contactTitle': contactTitle,
      'contactTitleFontSize': contactTitleFontSize,
      'contactTitleLetterSpacing': contactTitleLetterSpacing,
      'contactSubtitle': contactSubtitle,
      'contactSubtitleFontSize': contactSubtitleFontSize,
      'contactSubtitleLetterSpacing': contactSubtitleLetterSpacing,
    };
  }

  factory KeychainPdfLocaleModel.fromJson(Map<String, dynamic> json) {
    return KeychainPdfLocaleModel(
      locale: json['locale'] as String,
      contactTitle: json['contactTitle'] as String,
      contactTitleFontSize: (json['contactTitleFontSize'] as num).toDouble(),
      contactTitleLetterSpacing:
          (json['contactTitleLetterSpacing'] as num?)?.toDouble() ?? 0,
      contactSubtitle: json['contactSubtitle'] as String,
      contactSubtitleFontSize: (json['contactSubtitleFontSize'] as num)
          .toDouble(),
      contactSubtitleLetterSpacing:
          (json['contactSubtitleLetterSpacing'] as num?)?.toDouble() ?? 0,
    );
  }
}
