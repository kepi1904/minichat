import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minichat/data/utils/util.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class InitializeProvider extends ChangeNotifier {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  bool get error => _error;
  bool get initialized => _initialized;
  User? get user => _user;

  InitializeProvider() {
    initializeFlutterFire();
  }

  void initializeFlutterFire() {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        _user = user;
        _initialized = true;
        notifyListeners();
      });
    } catch (e) {
      _error = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere((u) => u.id != _user?.uid);
        color = getUserAvatarNameColor(otherUser);
      } catch (_) {}
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}
