import 'package:flutter/cupertino.dart';

void showAuthenticationErrorDialog(BuildContext context, String errorMessage) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return AuthenticationErrorDialog(errorMessage);
      });
}

class AuthenticationErrorDialog extends StatelessWidget {
  final errorMessage;
  AuthenticationErrorDialog(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text(errorMessage),
      actions: [
        CupertinoButton(
          child: const Text('ok'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
