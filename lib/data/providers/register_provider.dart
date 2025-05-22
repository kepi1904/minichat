import 'package:flutter/material.dart';
import 'package:minichat/data/repositories/auth_repository.dart';

import 'package:minichat/data/utils/notification_utils.dart';
import 'package:minichat/presentation/pages/auth/login_page.dart';

class RegisterProvider extends ChangeNotifier {
  RegisterProvider() {
    assert(() {
      return true;
    }());
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  FocusNode? focusNode;
  bool registering = false;
  bool loadings = false;
  String? _error;
  bool get isLoading => loadings;
  String? get error => _error;
  bool sloading = false;
  String? errors;
  final formKey = GlobalKey<FormState>();
  bool isHide = true;

  onHide() {
    isHide = !isHide;
    notifyListeners();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    isHide = true;
    notifyListeners();
  }

  void register(BuildContext context, String email, String password,
      String firstName, String lastName) async {
    FocusScope.of(context).unfocus();

    registering = true;
    loadings = true;
    notifyListeners();

    try {
      _setLoading(true);
      await _authRepository.register(email, password, firstName, lastName);
      clearForm();
      loadings = false;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      registering = false;
      loadings = false;
      notifyListeners();
      NotificationUtils.showDialogError(
        context,
        () {
          Navigator.of(context).pop();
        },
        widget: Text(
          e.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      );
      errors = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    sloading = value;
    notifyListeners();
  }
}
