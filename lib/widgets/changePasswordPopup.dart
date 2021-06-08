import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:provider/provider.dart';

changePasswordPopup(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return ChangePasswordConfirmation();
      });
}

class ChangePasswordConfirmation extends StatefulWidget {
  @override
  _ChangePasswordConfirmation createState() => _ChangePasswordConfirmation();
}

class _ChangePasswordConfirmation extends State<ChangePasswordConfirmation> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();
  final _passwordChangeErrorController = TextEditingController();
  var _isWrongPasswordErrorShown = false;
  var _isPasswordMismatchErrorShown = false;
  var _passwordChangeError = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Change password'),
      content: Column(
        children: [
          Text('Enter password to delete account'),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: CupertinoTextField(
              obscureText: true,
              placeholder: 'Old Password',
              controller: _oldPasswordController,
            ),
          ),
          Visibility(
            child: Text(
              'Enter correct password!',
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
            visible: _isWrongPasswordErrorShown,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: CupertinoTextField(
              obscureText: true,
              placeholder: 'New Password',
              controller: _newPasswordController,
            ),
          ),
          Visibility(
            child: Text(
              'Passwords have to match!',
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
            visible: _isPasswordMismatchErrorShown,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: CupertinoTextField(
              obscureText: true,
              placeholder: 'Confirm New Password',
              controller: _newPasswordConfirmationController,
            ),
          ),
          Visibility(
            child: Text(
              'Passwords have to match!',
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
            visible: _isPasswordMismatchErrorShown,
          ),
          Visibility(
            child: Text(
              _passwordChangeErrorController.text,
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
            visible: _passwordChangeError,
          )
        ],
      ),
      actions: [
        CupertinoButton(
          child: const Text('Confirm'),
          onPressed: () async {
            changePassword();
          },
        ),
        CupertinoButton(
          child: const Text('Cancel'),
          onPressed: () {
            _isWrongPasswordErrorShown = false;
            _isPasswordMismatchErrorShown = false;
            _passwordChangeError = false;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Future<void> changePassword() async {
    final _auth = context.read<AuthenticationService>();

    bool oldPasswordCorrect = true;
    bool newPasswordTheSame = true;
    User user = FirebaseAuth.instance.currentUser;
    final credential =
        await _auth.getCredentialForCurrentUser(_oldPasswordController.text);
    try {
      await _auth.reauthenticateWithRefreshedCredentials(credential);
      setState(() {
        _isWrongPasswordErrorShown = false;
      });
    } catch (e) {
      setState(() {
        oldPasswordCorrect = false;
        _isWrongPasswordErrorShown = true;
      });
    }
    if (_newPasswordController.text !=
        _newPasswordConfirmationController.text) {
      setState(() {
        newPasswordTheSame = false;
        _isPasswordMismatchErrorShown = true;
      });
    }
    else{
      setState(() {
        _isPasswordMismatchErrorShown = false;
      });
    }
    if (oldPasswordCorrect && newPasswordTheSame) {
      _isWrongPasswordErrorShown = false;
      _isPasswordMismatchErrorShown = false;
      _passwordChangeError = false;
      if(_newPasswordController.text!=_oldPasswordController.text) {
        user.updatePassword(_newPasswordController.text).then((_) {
          Navigator.pop(context);
        }).catchError((error) {
          setState(() {
            if(error.toString().contains('[firebase_auth/weak-password]')){
              _passwordChangeErrorController.text = 'Password has to be atleast 6 characters long!';
            }
            if(error.toString().contains('[firebase_auth/unknown]')){
              _passwordChangeErrorController.text = 'Password cannot be empty!';
            }
            _passwordChangeError = true;
          });
        });
      }
      else{
        setState(() {
          _passwordChangeErrorController.text = 'Passwords cannot be the same';
          _passwordChangeError =true;
        });
      }
    }
    // if (delete) {
    //   _auth.deleteUser();
    //   Navigator.pop(context);
    // }
  }
}
