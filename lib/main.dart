import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:xlo_auction_app/routes/register.dart';
import 'package:xlo_auction_app/routes/signIn.dart';
import 'package:xlo_auction_app/routes/home.dart';
import 'package:xlo_auction_app/themes/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(
          create: (_) => FirebaseFirestore.instance,
        ),
        Provider<FirebaseStorage>(
          create: (_) => FirebaseStorage.instance,
        ),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: CupertinoApp(
        title: 'XLO',
        initialRoute: '/',
        theme: CustomTheme.customTheme,
        routes: {
          '/': (context) => AuthenticationWrapper(),
          '/register': (context) => Register(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CupertinoTheme.of(context).barBackgroundColor,
      statusBarIconBrightness:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
    ));

    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }
    return SignIn();
  }
}
