part of 'product.dart';

class Attributes {
  final String? color;
  final String? size;
  final String? weight;
  final String? dimensions;

  const Attributes({this.color, this.size, this.weight, this.dimensions});

  factory Attributes.fromMap(Map<String, dynamic> data) => Attributes(
        color: data['color'] as String?,
        size: data['size'] as String?,
        weight: data['weight'] as String?,
        dimensions: data['dimensions'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'color': color,
        'size': size,
        'weight': weight,
        'dimensions': dimensions,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Attributes].
  factory Attributes.fromJson(String data) {
    return Attributes.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Attributes] to a JSON string.
  String toJson() => json.encode(toMap());

  Attributes copyWith({
    String? color,
    String? size,
    String? weight,
    String? dimensions,
  }) {
    return Attributes(
      color: color ?? this.color,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
    );
  }
}
