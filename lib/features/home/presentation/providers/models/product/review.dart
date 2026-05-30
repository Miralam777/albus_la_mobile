part of 'product.dart';

class Review {
  final String? reviewId;
  final String? user;
  final int? rating;
  final String? comment;
  final String? date;

  const Review({
    this.reviewId,
    this.user,
    this.rating,
    this.comment,
    this.date,
  });

  factory Review.fromMap(Map<String, dynamic> data) => Review(
        reviewId: data['reviewId'] as String?,
        user: data['user'] as String?,
        rating: data['rating'] as int?,
        comment: data['comment'] as String?,
        date: data['date'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'reviewId': reviewId,
        'user': user,
        'rating': rating,
        'comment': comment,
        'date': date,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Review].
  factory Review.fromJson(String data) {
    return Review.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Review] to a JSON string.
  String toJson() => json.encode(toMap());

  Review copyWith({
    String? reviewId,
    String? user,
    int? rating,
    String? comment,
    String? date,
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      user: user ?? this.user,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }
}
