import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:minichat/data/locals/shared_preferences.dart';
import 'package:minichat/data/utils/notification_utils.dart';
import 'package:minichat/presentation/pages/auth/login_page.dart';
import 'package:minichat/presentation/pages/home/home_page.dart';
import 'package:minichat/presentation/pages/profile/profile_page.dart';
import 'package:minichat/data/utils/util.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    assert(() {
      initTheme();
      notifyListeners();
      return true;
    }());
  }

  final bool _error = false;
  final bool _initialized = false;
  User? _user;

  bool get error => _error;
  bool get initialized => _initialized;
  User? get user => _user;
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
        radius: 30.h,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    NotificationUtils.showDialogError(
      context,
      () async {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      },
      widget: Text(
        'Are you sure you want to logout?',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    ProfilePage(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  //theme settings
  ThemeMode _themeMode = ThemeMode.light;

  void initTheme() async {
    _themeMode = await PreferenceHandler.retrieveTheme() == "1"
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    await PreferenceHandler.storingTheme(isOn ? "1" : "0");
    notifyListeners();
  }
}
