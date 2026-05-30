import 'package:albus_la_mobile/configs/network/network_info.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrderProvider extends ChangeNotifier {
  List<Orders> _orders = [];
  List<Orders> get getOrders => _orders;

  // TODO: clean
  /*   Future<void> init() async {
    FirebaseFirestore.instance
        .collection('orders')
        .where('isDone', isEqualTo: false)
        // .orderBy('created', descending: true)
        .snapshots()
        .listen((snapshot) {
      final sortedDocs = snapshot.docs
        ..sort((a, b) {
          final createdA = (a['created'] as Timestamp).toDate();
          final createdB = (b['created'] as Timestamp).toDate();
          return createdB.compareTo(createdA);
        });

      List<Orders> ords = [];

      for (var d in sortedDocs) {
        final doc = d.data();
        final order = Orders.fromMap(doc);
        ords.add(order);
      }

      _orders = ords;
      notifyListeners();
    }, onError: (_) {
      // Fehlerbehandlung
    });
  } */
  Future<void> init() async {
    FirebaseFirestore.instance
        .collection('orders')
        .where('isDone', isEqualTo: false)
        .orderBy('created', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.docs.isNotEmpty) {
              _orders = snapshot.docs
                  .map((doc) => Orders.fromMap(doc.data()))
                  .toList();
            } else {
              _orders = [];
            }

            notifyListeners();
          },
          onError: (_) {
            // Fehlerbehandlung
          },
        );
  }

  Future<List<Orders>> getLast100DoneOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('isDone', isEqualTo: true)
          .orderBy('created', descending: true)
          .limit(100)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) => Orders.fromMap(doc.data())).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> orderDone({required String dId, required String doneUId}) async {
    try {
      if (await NetworkInfo().isConnected) {
        await FirebaseFirestore.instance.collection('orders').doc(dId).update({
          'doneDate': FieldValue.serverTimestamp(),
          'doneUId': doneUId,
          'inWork': false,
          'isDone': true,
        });
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> setInWork({
    required String dId,
    required bool inWork,
    required String? doneUId,
  }) async {
    try {
      if (await NetworkInfo().isConnected) {
        await FirebaseFirestore.instance.collection('orders').doc(dId).update({
          'inWork': inWork,
          'doneUId': doneUId,
        });
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> isInWork({required String dId}) async {
    try {
      if (await NetworkInfo().isConnected) {
        final snapshot = await FirebaseFirestore.instance
            .collection('orders')
            .doc(dId)
            .get();

        if (snapshot.exists) {
          return snapshot.data()?['inWork'] ?? false;
        }
      }
    } catch (_) {}
    return false;
  }
}
