import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
          '/signIn': (context) => SignIn(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: CupertinoTheme.of(context).barBackgroundColor,
        statusBarIconBrightness: CupertinoTheme.of(context).brightness));
    if (firebaseUser != null) {
      return HomePage();
    }
    return Register();
  }
}
