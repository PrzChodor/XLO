import 'package:flutter/cupertino.dart';

void showNotification(
    BuildContext context, String errorTitle, String errorMessage) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return NotificationDialog(errorTitle, errorMessage);
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
