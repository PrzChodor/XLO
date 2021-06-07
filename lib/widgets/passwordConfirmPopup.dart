import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:provider/provider.dart';

void showPasswordPopup(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return PasswordConfirmation();
      });
}

class PasswordConfirmation extends StatefulWidget {
  @override
  _PasswordConfirmationState createState() => _PasswordConfirmationState();
}

class _PasswordConfirmationState extends State<PasswordConfirmation> {
  final _passwordController = TextEditingController();
  var _isErrorShown = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthenticationService>();

    return CupertinoAlertDialog(
      title: Text('Delete account'),
      content: Column(
        children: [
          Text('Enter password to delete account'),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: CupertinoTextField(
              placeholder: 'Password',
              controller: _passwordController,
            ),
          ),
          Visibility(
            child: Text(
              'Enter correct password!',
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
            visible: _isErrorShown,
          )
        ],
      ),
      actions: [
        CupertinoButton(
          child: const Text('Confirm'),
          onPressed: () async {
            bool delete = true;

            final credential =
                _auth.getCredentialForCurrentUser(_passwordController.text);
            try {
              await _auth.reauthenticateWithRefreshedCredentials(credential);
            } catch (e) {
              delete = false;
              setState(() {
                _isErrorShown = !_isErrorShown;
              });
            }
            if (delete) {
              _auth.deleteUser();
              Navigator.pop(context);
            }
          },
        ),
        CupertinoButton(
          child: const Text('Cancel'),
          onPressed: () {
            _isErrorShown = false;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
