import 'dart:convert';
import 'package:albus_la_mobile/configs/services/firebase/firebase_auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserProvider extends ChangeNotifier {
  UserInfos? _userInfos;
  UserInfos? get userInfos => _userInfos;

  List<UserInfos?>? _admins;
  List<UserInfos?>? get getAdmins => _admins;

  Future<void> init(String uId) async {
    FirebaseFirestore.instance.collection('admins').doc(uId).snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          _userInfos = UserInfos.fromMap(snapshot.data() ?? {});
          notifyListeners();
        }
      },
    );
  }

  Future<void> fetchAdmins() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .get();

      _admins = querySnapshot.docs
          .map((doc) => UserInfos.fromMap(doc.data()))
          .toList();

      notifyListeners();
    } catch (_) {}
  }

  Future<void> updateAdmins(UserInfos? userInfos) async {
    try {
      if (userInfos != null) {
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(userInfos.uId)
            .update(userInfos.toMap());

        await fetchAdmins();
        notifyListeners();
      }
    } catch (_) {}
  }

  UserInfos? getAdminByUId(String? uId) {
    for (UserInfos? admin in _admins ?? []) {
      if (admin?.uId == uId) return admin;
    }
    return null;
  }

  void logout() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(_userInfos?.uId)
        .update({'fcm': null});
    await AuthService.logout();
    try {} catch (_) {}
  }

  Future<void> setFcmAndLogoutTrigger({
    required String uId,
    required String newLogoutTrigger,
  }) async {
    final fcm = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('admins').doc(uId).update({
      "fcm": fcm,
      "logoutTrigger": newLogoutTrigger,
    });
  }

  Future<void> updatePush() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(_userInfos?.uId ?? '')
        .update({"isPushActive": !(_userInfos?.isPushActive ?? false)});
  }

  Future<bool> isBlockedOrLogoutTriggerChanged({
    required String uId,
    required String logoutTrigger,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc(uId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData = snapshot.data();
        final isBlocked = userData?['isBlocked'] ?? true;
        final isTriggerChanged =
            (userData?['logoutTrigger'] ?? '') != logoutTrigger;
        print('isBlocked: $isBlocked');
        print('isTriggerChanged: $isTriggerChanged');
        if (isBlocked || isTriggerChanged) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  Future<bool> isLogoutTriggerChanged({
    required String uId,
    required String logoutTrigger,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc(uId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData = snapshot.data();
        return (userData?['logoutTrigger'] ?? '') as bool;
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }
}

class UserInfos {
  final String? uId;
  final String? avatar;
  final String? logoutTrigger;
  // TODO: timestamp
  final Timestamp? created;
  final String? fcm;
  final String? email;
  final String? firstname;
  final String? surname;
  final String? telNr;
  final String? location;
  final String? role;
  final bool? isAdmin;
  final bool? isBlocked;
  final bool? isPushActive;
  final List<String>? viewIds;

  const UserInfos({
    this.uId,
    this.avatar,
    this.logoutTrigger,
    this.created,
    this.fcm,
    this.email,
    this.firstname,
    this.surname,
    this.telNr,
    this.location,
    this.role,
    this.isAdmin,
    this.isBlocked,
    this.isPushActive,
    this.viewIds,
  });

  factory UserInfos.fromMap(Map<String, dynamic> data) {
    return UserInfos(
      uId: data['uId'] as String?,
      avatar: data['avatar'] as String?,
      logoutTrigger: data['logoutTrigger'] as String?,
      created: data['created'] as Timestamp?,
      fcm: data['fcm'] as String?,
      email: data['email'] as String?,
      firstname: data['firstname'] as String?,
      surname: data['surname'] as String?,
      telNr: data['telNr'] as String?,
      location: data['location'] as String?,
      role: data['role'] as String?,
      isAdmin: data['isAdmin'] as bool?,
      isBlocked: data['isBlocked'] as bool?,
      isPushActive: data['isPushActive'] as bool?,
      viewIds: data['viewIds'] != null
          ? (data['viewIds'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
    'uId': uId,
    'avatar': avatar,
    'logoutTrigger': logoutTrigger,
    'created': created,
    'fcm': fcm,
    'email': email,
    'firstname': firstname,
    'surname': surname,
    'telNr': telNr,
    'location': location,
    'role': role,
    'isAdmin': isAdmin,
    'isBlocked': isBlocked,
    'isPushActive': isPushActive,
    'viewIds': viewIds,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserInfos].
  factory UserInfos.fromJson(String data) {
    return UserInfos.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserInfos] to a JSON string.
  String toJson() => json.encode(toMap());

  UserInfos copyWith({
    String? uId,
    String? avatar,
    String? logoutTrigger,
    // TODO: timestamp
    Timestamp? created,
    String? fcm,
    String? email,
    String? firstname,
    String? surname,
    String? telNr,
    String? location,
    String? role,
    bool? isAdmin,
    bool? isBlocked,
    bool? isPushActive,
    List<String>? viewIds,
  }) {
    return UserInfos(
      uId: uId ?? this.uId,
      avatar: avatar ?? this.avatar,
      logoutTrigger: logoutTrigger ?? this.logoutTrigger,
      created: created ?? this.created,
      fcm: fcm ?? this.fcm,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      surname: surname ?? this.surname,
      telNr: telNr ?? this.telNr,
      location: location ?? this.location,
      role: role ?? this.role,
      isAdmin: isAdmin ?? this.isAdmin,
      isBlocked: isBlocked ?? this.isBlocked,
      isPushActive: isPushActive ?? this.isPushActive,
      viewIds: viewIds ?? this.viewIds,
    );
  }
}
