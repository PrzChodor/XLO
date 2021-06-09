import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:xlo_auction_app/routes/ads_active.dart';
import 'package:xlo_auction_app/routes/ads_archived.dart';
import 'package:xlo_auction_app/widgets/changePasswordPopup.dart';
import 'package:xlo_auction_app/widgets/deletionConfirmPopup.dart';
import 'package:xlo_auction_app/routes/new_ad.dart';
import 'package:xlo_auction_app/themes/custom_theme.dart';
import 'package:xlo_auction_app/widgets/notification.dart';
import 'package:xlo_auction_app/widgets/sliver_fill_remaining_box_adapter.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> with ScreenLoader<UserProfile> {
  @override
  Widget screen(BuildContext context) {
    final _auth = Provider.of<AuthenticationService>(context);
    return WillPopScope(
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: Text('Profile'),
              ),
              SliverFillRemainingBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: CupertinoTheme.of(context).barBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      CupertinoTheme.of(context).primaryColor,
                                ),
                                width: 96,
                                height: 96,
                                child: GestureDetector(
                                    child: _auth.getCurrentUserPhoto() != null
                                        ? Image.network(
                                            _auth.getCurrentUserPhoto(),
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            CupertinoIcons.person_fill,
                                            color: CupertinoTheme.of(context)
                                                .barBackgroundColor,
                                            size: 80,
                                          ),
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      await this
                                          .performFuture(() => changePhoto());
                                    }),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          'Logged in as',
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .navTitleTextStyle,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          _auth.getCurrentUsername(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .navLargeTitleTextStyle
                                              .merge(TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color:
                                CupertinoTheme.of(context).barBackgroundColor,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              CupertinoButton(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.add),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Text('Add new advertisement'),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => NewAd()));
                                },
                              ),
                              Divider(
                                height: 1,
                              ),
                              CupertinoButton(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.list_bullet),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Text('Active'),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context, rootNavigator: true)
                                      .push(CupertinoPageRoute(
                                          builder: (context) => AdsActive()));
                                },
                              ),
                              Divider(
                                height: 1,
                              ),
                              CupertinoButton(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.archivebox),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Text('Archived'),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context, rootNavigator: true)
                                      .push(CupertinoPageRoute(
                                          builder: (context) => AdsArchived()));
                                },
                              ),
                              Divider(
                                height: 1,
                              ),
                              CupertinoButton(
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.paintbrush),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Text('Select theme'),
                                    ),
                                  ],
                                ),
                                onPressed: () => showThemePicker(context),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: CupertinoTheme.of(context).barBackgroundColor,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            CupertinoButton(
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.power,
                                    color: CupertinoColors.destructiveRed,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Log out',
                                      style: TextStyle(
                                          color:
                                              CupertinoColors.destructiveRed),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => _auth.signOut(),
                            ),
                            Divider(
                              height: 1,
                            ),
                            AuthenticationService().isCurrentProviderByEmail()
                                ? CupertinoButton(
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.lock,
                                          color: CupertinoColors.destructiveRed,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Change password',
                                            style: TextStyle(
                                                color: CupertinoColors
                                                    .destructiveRed),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () => changePassword(context),
                                  )
                                : Container(),
                            AuthenticationService().isCurrentProviderByEmail()
                                ? Divider(
                                    height: 1,
                                  )
                                : Container(),
                            CupertinoButton(
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.delete,
                                    color: CupertinoColors.destructiveRed,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Delete account',
                                      style: TextStyle(
                                          color:
                                              CupertinoColors.destructiveRed),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => deleteUser(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return !isLoading;
      },
    );
  }

  loader() {
    return CupertinoActivityIndicator(
        radius: min(MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.1));
  }

  showThemePicker(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoTheme.of(context).barBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 150,
              child: CupertinoPicker(
                itemExtent: 50,
                children: [
                  Center(child: Text('Use system theme')),
                  Center(child: Text('Light theme')),
                  Center(child: Text('Dark theme')),
                ],
                onSelectedItemChanged: (index) {
                  switch (index) {
                    case 0:
                      CustomTheme.changeBrightness(true, Brightness.light);
                      break;
                    case 1:
                      CustomTheme.changeBrightness(false, Brightness.light);
                      break;
                    case 2:
                      CustomTheme.changeBrightness(false, Brightness.dark);
                      break;
                    default:
                  }
                },
              ),
            ),
            CupertinoButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> changePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final loggedUser = AuthenticationService().getCurrentUserId();
      final taskSnapshot = await FirebaseStorage.instance
          .ref('$loggedUser/profile_photo')
          .putFile(File(pickedFile.path))
          .catchError((error, stackTrace) {
        showNotification(context, 'Error', "Failed to upload image!\n$error");
      });
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
      setState(() {});
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    showPasswordPopup(context);
  }

  Future<void> changePassword(BuildContext context) async {
    changePasswordPopup(context);
  }
}
