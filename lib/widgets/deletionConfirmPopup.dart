import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:provider/provider.dart';
import 'package:algolia/algolia.dart';
import 'package:xlo_auction_app/widgets/notification.dart';

void showPasswordPopup(BuildContext context) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return DeletionConfirmation();
      });
}

class DeletionConfirmation extends StatefulWidget {
  @override
  _DeletionConfirmationState createState() => _DeletionConfirmationState();
}

class _DeletionConfirmationState extends State<DeletionConfirmation> {
  final _passwordController = TextEditingController();
  var _isErrorShown = false;
  var _isEmailAccount = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final _auth = context.read<AuthenticationService>();
    _isEmailAccount = _auth.isCurrentProviderByEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Delete account'),
      content: Visibility(
        visible: _isEmailAccount,
        child: Column(
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
      ),
      actions: [
        CupertinoButton(
          child: const Text('Confirm'),
          onPressed: () => {
            archiveDocumentsInBase(),
            deleteAccount(),
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

  Future<void> deleteAccount() async {
    final _auth = context.read<AuthenticationService>();
    bool delete = true;

    if (_isEmailAccount) {
      final credential =
          await _auth.getCredentialForCurrentUser(_passwordController.text);
      try {
        await _auth.reauthenticateWithRefreshedCredentials(credential);
      } catch (e) {
        delete = false;
        setState(() {
          _isErrorShown = !_isErrorShown;
        });
      }
    } else {
      _auth.signOutFacebookAndGoogle();
    }

    if (delete) {
      try {
        await _auth.deleteUser();
      } catch (e) {
        Navigator.pop(context);
        showNotification(context, 'You must sign in again',
            'You need to reauthenticate to delete your account');
        await _auth.signOut();
        return;
      }
      Navigator.pop(context);
    }
  }

  Future<void> archiveDocumentsInBase() async {
    final _auth = context.read<AuthenticationService>();
    Algolia algolia = Algolia.init(
      applicationId: 'ZYVN1G1S7E',
      apiKey: '074c9f69d125d3d81260e64fb5424ace',
    );
    AlgoliaIndexReference index = algolia.instance.index('ads');

    final list = await FirebaseFirestore.instance
        .collection('ads')
        .where('ownerID', isEqualTo: _auth.getCurrentUserId())
        .where('archived', isEqualTo: false)
        .get();
    list.docs.forEach((snapshot) {
      final document = snapshot.reference;
      document.update({'archived': true});
      index.addObject({
        'objectID': document.id,
        'title': snapshot.data()['title'],
        'archived': true,
        'date': DateTime.now()
      });
    });
  }
}
