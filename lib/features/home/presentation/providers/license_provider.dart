import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'models/license/license.dart';

@injectable
class LicenseProvider extends ChangeNotifier {
  List<License> _licenses = [];
  List<License> get getLicenses => _licenses;

  Future<void> init() async {
    FirebaseFirestore.instance
        .collection('licenses')
        .orderBy('created', descending: false)
        .snapshots()
        .listen((snapshot) {
      print('products snapshot.docs.length');
      print(snapshot.docs.length);
      List<License> licenses = [];
      for (var l in snapshot.docs) {
        final doc = l.data();
        final lice = License.fromMap(doc);
        licenses.add(lice);
      }

      _licenses = licenses;
      notifyListeners();
    }, onError: (_) {
      // Fehlerbehandlung
    });
  }

  Future<void> add(License license) async {
    try {
      String dId = FirebaseFirestore.instance.collection('licenses').doc().id;
      print('dId: ${dId}');

      await FirebaseFirestore.instance
          .collection('licenses')
          .doc(dId)
          .set(license.copyWith(dId: dId).toMap());
    } catch (error) {
      print('Fehler beim Hinzufügen der Kategorie: $error');
    }
  }

  Future<void> update(License? license) async {
    try {
      if (license != null) {
        await FirebaseFirestore.instance
            .collection('licenses')
            .doc(license.dId)
            .update(license.toMap());
      }
    } catch (_) {}
  }

  Future<void> delete(String? dId) async {
    try {
      //! delete product
      await FirebaseFirestore.instance.collection('licenses').doc(dId).delete();
    } catch (_) {}
  }
}
