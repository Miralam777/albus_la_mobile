import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

// TODO: remove
@injectable
class GenQrcodesProvider extends ChangeNotifier {
  List<GenProduct> _qrcodes = [];
  List<GenProduct> get getQrcodes => _qrcodes;

  Future<void> init() async {
    FirebaseFirestore.instance
        .collection('products')
        .where('uId', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            _qrcodes = snapshot.docs
                .map((d) => GenProduct.fromMap(d.data()))
                .toList();

            notifyListeners();
          },
          onError: (_) {
            // Fehlerbehandlung
          },
        );
  }
}
