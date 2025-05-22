import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider() {
    assert(() {
      return true;
    }());
  }

  String? firstName;
  String? imageUrl;

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      firstName = null;
      notifyListeners();
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        firstName = doc.data()?['firstName'];
        imageUrl = doc.data()?['imageUrl'];
      } else {
        firstName = null;
      }
      notifyListeners();
    } catch (e) {
      print('Gagal memuat profil user: $e');
    }
  }
}
