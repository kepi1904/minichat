import 'package:flutter/material.dart';
import 'package:minichat/presentation/widgets/button_notification.dart';

class NotificationUtils {
  static Future<void> showDialogError(
      BuildContext context, void Function() onPress,
      {Widget? widget, String? textButton}) async {
    await showDialog(
      context: context,
      barrierDismissible:
          false, // Memastikan dialog tidak dapat ditutup dengan mengklik di luar
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Menonaktifkan tombol back
        child: AlertDialog(
          title: Center(
            child: Image.asset(
              "assets/icons/error.png",
              width: 50,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: widget ?? Container(),
          scrollable: true,
          actions: <Widget>[
            SizedBox(
              height: 54,
              child: ButtonNotification(
                textButton ?? 'Ok',
                expand: true,
                radius: 10,
                onPress: onPress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
