import 'package:flutter/cupertino.dart';

void showNotification(
    BuildContext context, String title, String message) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return NotificationDialog(title, message);
      });
}

class NotificationDialog extends StatelessWidget {
  final errorTitle;
  final errorMessage;
  NotificationDialog(this.errorTitle, this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(errorTitle),
      content: Text(errorMessage),
      actions: [
        CupertinoButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
