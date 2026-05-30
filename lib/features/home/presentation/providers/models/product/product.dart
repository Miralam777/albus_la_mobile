import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

part 'attributes.dart';
part 'review.dart';
part 'supplier.dart';

class Product {
  final String? dId;
  final int? productId;
  final bool? isActive;
  final String? name;
  final String? labelName;
  final String? description;
  final String? category;
  final int? amount;
  final int? price;
  final int? avt;
  final String? currency;
  final int? stock;
  final double? rating;
  final String? thumbnail;
  final List<String>? images;
  final Attributes? attributes;
  final List<String>? tags;
  final List<Review>? reviews;
  final List<String>? relatedProducts;
  final Timestamp? created;
  final Supplier? supplier;

  const Product({
    this.dId,
    this.productId,
    this.isActive,
    this.name,
    this.labelName,
    this.description,
    this.category,
    this.amount,
    this.price,
    this.avt,
    this.currency,
    this.stock,
    this.rating,
    this.thumbnail,
    this.images,
    this.attributes,
    this.tags,
    this.reviews,
    this.relatedProducts,
    this.created,
    this.supplier,
  });

  factory Product.fromMap(Map<String, dynamic> data) => Product(
        dId: data['dId'] as String?,
        productId: data['productId'] as int?,
        isActive: data['isActive'] as bool?,
        name: data['name'] as String?,
        labelName: data['labelName'] as String?,
        description: data['description'] as String?,
        category: data['category'] as String?,
        amount: data['amount'] as int?,
        price: data['price'] as int?,
        avt: data['avt'] as int?,
        currency: data['currency'] as String?,
        stock: data['stock'] as int?,
        rating: (data['rating'] as num?)?.toDouble(),
        thumbnail: data['thumbnail'] as String?,
        images:
            (data['images'] ?? []).map<String>((e) => e.toString()).toList(),
        attributes: data['attributes'] == null
            ? null
            : Attributes.fromMap(data['attributes'] as Map<String, dynamic>),
        tags: (data['tags'] ?? []).map<String>((e) => e.toString()).toList(),
        reviews: (data['reviews'] as List<dynamic>?)
            ?.map<Review>((e) => Review.fromMap(e as Map<String, dynamic>))
            .toList(),
        relatedProducts: (data['relatedProducts'] ?? [])
            .map<String>((e) => e.toString())
            .toList(),
        created: data['created'].runtimeType == String
            ? Timestamp.fromDate(DateTime.parse(data['created']))
            : data['created'] as Timestamp?,
        supplier: data['supplier'] == null
            ? null
            : Supplier.fromMap(data['supplier'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'dId': dId,
        'productId': productId,
        'isActive': isActive,
        'name': name,
        'labelName': labelName,
        'description': description,
        'category': category,
        'amount': amount,
        'price': price,
        'avt': avt,
        'currency': currency,
        'stock': stock,
        'rating': rating,
        'thumbnail': thumbnail,
        'images': images,
        'attributes': attributes?.toMap(),
        'tags': tags,
        'reviews': reviews?.map((e) => e.toMap()).toList(),
        'relatedProducts': relatedProducts,
        'created': created,
        'supplier': supplier?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory Product.fromJson(String data) {
    return Product.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Product] to a JSON string.
  String toJson() => json.encode(toMap());

  Product copyWith({
    String? dId,
    int? productId,
    bool? isActive,
    String? name,
    String? labelName,
    String? description,
    String? category,
    int? amount,
    int? price,
    int? avt,
    String? currency,
    int? stock,
    double? rating,
    String? thumbnail,
    List<String>? images,
    Attributes? attributes,
    List<String>? tags,
    List<Review>? reviews,
    List<String>? relatedProducts,
    Timestamp? created,
    Supplier? supplier,
  }) {
    return Product(
      dId: dId ?? this.dId,
      productId: productId ?? this.productId,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      labelName: labelName ?? this.labelName,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      avt: avt ?? this.avt,
      currency: currency ?? this.currency,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      attributes: attributes ?? this.attributes,
      tags: tags ?? this.tags,
      reviews: reviews ?? this.reviews,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      created: created ?? this.created,
      supplier: supplier ?? this.supplier,
    );
  }
}
