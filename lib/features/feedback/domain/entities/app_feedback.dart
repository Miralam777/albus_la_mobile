import 'dart:convert';
import 'package:equatable/equatable.dart';

class AppFeedback extends Equatable {
  final String? appId;
  final String? email;
  final Map<String, dynamic>? userAgent;
  final String subject;
  final String feedback;

  const AppFeedback({
    this.appId,
    this.email,
    this.userAgent,
    required this.subject,
    required this.feedback,
  });

  factory AppFeedback.fromMap(Map<String, dynamic> data) => AppFeedback(
        appId: data['appId'],
        email: data['email'],
        userAgent: data['userAgent'],
        subject: data['subject'],
        feedback: data['feedback'],
      );

  Map<String, dynamic> toMap() => {
        'appId': appId,
        'email': email,
        'userAgent': userAgent,
        'subject': subject,
        'feedback': feedback,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AppFeedback].
  factory AppFeedback.fromJson(String data) {
    return AppFeedback.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AppFeedback] to a JSON string.
  String toJson() => json.encode(toMap());

  AppFeedback copyWith({
    String? appId,
    String? email,
    Map<String, dynamic>? userAgent,
    String? subject,
    String? feedback,
  }) {
    return AppFeedback(
      appId: appId ?? this.appId,
      email: email ?? this.email,
      userAgent: userAgent ?? this.userAgent,
      subject: subject ?? this.subject,
      feedback: feedback ?? this.feedback,
    );
  }

  @override
  List<Object?> get props => [appId, email, userAgent, subject, feedback];
}
