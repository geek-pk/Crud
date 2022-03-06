import 'package:crud/pages/homepage.dart';
import 'package:crud/pages/sign_in_page.dart';
import 'package:crud/themes/themes.dart';
import 'package:crud/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkAccount(context);
    return Container();
  }

  checkAccount(context) async {
    var account = await FirebaseAuth.instance.currentUser;
    if (account == null) {
      navigatePushReplacement(context, const SignInPage());
    } else {
      navigatePushReplacement(context, const HomePage());
    }
  }
}
