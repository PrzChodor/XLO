import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlo_auction_app/authentication/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:xlo_auction_app/routes/register.dart';
import 'package:xlo_auction_app/routes/signIn.dart';
import 'package:xlo_auction_app/routes/home.dart';
import 'package:xlo_auction_app/themes/custom_theme.dart';

SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _brightness = Brightness.light;
  bool _auto = true;

  void _changeBrightness(bool auto, Brightness newBrightness) async {
    CustomTheme.autoBrightness = auto;
    CustomTheme.currentBrightness = newBrightness;
    setState(() {
      _brightness = newBrightness;
      _auto = auto;
    });

    prefs.setBool('brightness', newBrightness == Brightness.dark);
    prefs.setBool('autoBrightness', auto);
  }

  @override
  void initState() {
    if (prefs.containsKey('brightness')) {
      _brightness =
          prefs.getBool('brightness') ? Brightness.dark : Brightness.light;
      CustomTheme.currentBrightness = _brightness;
    }
    if (prefs.containsKey('autoBrightness')) {
      _auto = prefs.getBool('autoBrightness');
      CustomTheme.autoBrightness = _auto;
    }

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomTheme.changeBrightness = _changeBrightness;
    });
  }

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
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        title: 'XLO',
        initialRoute: '/',
        theme: _auto
            ? CustomTheme.customTheme
            : CustomTheme.customTheme.copyWith(brightness: _brightness),
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
    final _auto = CustomTheme.autoBrightness;
    final _brightness = _auto
        ? MediaQuery.of(context).platformBrightness
        : CustomTheme.currentBrightness;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CupertinoTheme.of(context).barBackgroundColor,
      statusBarIconBrightness:
          _brightness == Brightness.light ? Brightness.dark : Brightness.light,
    ));

    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }
    return SignIn();
  }
}
