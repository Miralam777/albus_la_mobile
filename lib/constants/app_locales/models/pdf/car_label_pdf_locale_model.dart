class CarLabelPdfLocaleModel {
  final String locale;
  final String contactTitle;
  final double contactTitleFontSize;
  final double contactTitleLetterSpacing;
  final String contactSubtitle;
  final double contactSubtitleFontSize;
  final double contactSubtitleLetterSpacing;
  final String activationCodeTitle;
  final String contactTitleV2;
  final double contactTitleFontSizeV2;
  final double contactTitleLetterSpacingV2;
  final String contactSubtitleV2;
  final double contactSubtitleFontSizeV2;
  final double contactSubtitleLetterSpacingV2;

  CarLabelPdfLocaleModel({
    required this.locale,
    required this.contactTitle,
    required this.contactTitleFontSize,
    this.contactTitleLetterSpacing = 0,
    required this.contactSubtitle,
    required this.contactSubtitleFontSize,
    this.contactSubtitleLetterSpacing = 0,
    required this.activationCodeTitle,
    required this.contactTitleV2,
    required this.contactTitleFontSizeV2,
    this.contactTitleLetterSpacingV2 = 0,
    required this.contactSubtitleV2,
    required this.contactSubtitleFontSizeV2,
    this.contactSubtitleLetterSpacingV2 = 0,
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
      'activationCodeTitle': activationCodeTitle,
      'contactTitleV2': contactTitleV2,
      'contactTitleFontSizeV2': contactTitleFontSizeV2,
      'contactTitleLetterSpacingV2': contactTitleLetterSpacingV2,
      'contactSubtitleV2': contactSubtitleV2,
      'contactSubtitleFontSizeV2': contactSubtitleFontSizeV2,
      'contactSubtitleLetterSpacingV2': contactSubtitleLetterSpacingV2,
    };
  }

  factory CarLabelPdfLocaleModel.fromJson(Map<String, dynamic> json) {
    return CarLabelPdfLocaleModel(
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
      activationCodeTitle: json['activationCodeTitle'] as String,
      contactTitleV2: json['contactTitleV2'] as String,
      contactTitleFontSizeV2: (json['contactTitleFontSizeV2'] as num)
          .toDouble(),
      contactTitleLetterSpacingV2:
          (json['contactTitleLetterSpacingV2'] as num?)?.toDouble() ?? 0,
      contactSubtitleV2: json['contactSubtitleV2'] as String,
      contactSubtitleFontSizeV2: (json['contactSubtitleFontSizeV2'] as num)
          .toDouble(),
      contactSubtitleLetterSpacingV2:
          (json['contactSubtitleLetterSpacingV2'] as num?)?.toDouble() ?? 0,
    );
  }
}
