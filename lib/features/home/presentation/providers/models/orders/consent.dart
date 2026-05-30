import 'dart:convert';

class Consent {
  final bool? termsAccepted;
  final bool? privacyPolicyAccepted;
  final bool? newsletterOptIn;

  const Consent({
    this.termsAccepted,
    this.privacyPolicyAccepted,
    this.newsletterOptIn,
  });

  factory Consent.fromMap(Map<String, dynamic> data) => Consent(
        termsAccepted: data['termsAccepted'] as bool?,
        privacyPolicyAccepted: data['privacyPolicyAccepted'] as bool?,
        newsletterOptIn: data['newsletterOptIn'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'termsAccepted': termsAccepted,
        'privacyPolicyAccepted': privacyPolicyAccepted,
        'newsletterOptIn': newsletterOptIn,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Consent].
  factory Consent.fromJson(String data) {
    return Consent.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Consent] to a JSON string.
  String toJson() => json.encode(toMap());

  Consent copyWith({
    bool? termsAccepted,
    bool? privacyPolicyAccepted,
    bool? newsletterOptIn,
  }) {
    return Consent(
      termsAccepted: termsAccepted ?? this.termsAccepted,
      privacyPolicyAccepted:
          privacyPolicyAccepted ?? this.privacyPolicyAccepted,
      newsletterOptIn: newsletterOptIn ?? this.newsletterOptIn,
    );
  }
}
