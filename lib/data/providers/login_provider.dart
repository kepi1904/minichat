import 'package:flutter/material.dart';
import 'package:minichat/data/repositories/auth_repository.dart';
import 'package:minichat/data/utils/notification_utils.dart';
import 'package:minichat/presentation/pages/home/navigation_page.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    assert(() {
      return true;
    }());
  }

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool _loading = false;
  String? _error;
  bool get isLoading => _loading;
  String? get error => _error;
  final AuthRepository _authRepository = AuthRepository();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool isHide = true;

  onHide() {
    isHide = !isHide;
    notifyListeners();
  }

  Future<void> doLogin(BuildContext context) async {
    final success = await login(
      emailController.text.trim(),
      passController.text.trim(),
    );
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => NavigationPage(),
        ),
      );
    } else {
      final error = _error ?? 'Unknown error';
      NotificationUtils.showDialogError(context, () {
        Navigator.of(context).pop();
      },
          widget: Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ));
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _loading = true;
    try {
      await _authRepository.login(email, password);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
      _loading = false;
      notifyListeners();
    }
  }

  onPressGoogle(BuildContext context) async {
    final success = await _authRepository.signInWithGoogle(context);
    if (success != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => NavigationPage(),
        ),
      );
    } else {
      final error = _error ?? 'Unknown error';
      NotificationUtils.showDialogError(context, () {
        Navigator.of(context).pop();
      },
          widget: Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ));
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
