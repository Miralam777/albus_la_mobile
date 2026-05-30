part of 'product.dart';

class Supplier {
  final String? supplierId;
  final String? name;
  final String? contact;
  final String? phone;

  const Supplier({this.supplierId, this.name, this.contact, this.phone});

  factory Supplier.fromMap(Map<String, dynamic> data) => Supplier(
        supplierId: data['supplierId'] as String?,
        name: data['name'] as String?,
        contact: data['contact'] as String?,
        phone: data['phone'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'supplierId': supplierId,
        'name': name,
        'contact': contact,
        'phone': phone,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Supplier].
  factory Supplier.fromJson(String data) {
    return Supplier.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Supplier] to a JSON string.
  String toJson() => json.encode(toMap());

  Supplier copyWith({
    String? supplierId,
    String? name,
    String? contact,
    String? phone,
  }) {
    return Supplier(
      supplierId: supplierId ?? this.supplierId,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
    );
  }
}
