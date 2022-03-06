import 'package:crud/pages/otp_verify_page.dart';
import 'package:crud/themes/colors.dart';
import 'package:crud/utils.dart';
import 'package:crud/widgets/theme_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool loader = false;
  late String phone;
  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Continue with Phone',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 40),
              TextField(
                maxLength: 10,
                keyboardType: TextInputType.phone,
                onChanged: (onChanged) => phone = onChanged,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: colorPrimary),
                  hintText: 'Enter Phone',
                  label: Text('Phone'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ThemeButton(
                    title: 'CONTINUE',
                    loader: loader,
                    onPress: signIn,
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    if (phone.length < 10 || loader == true) {
      showToast('Please enter a valid phone');
      return;
    }
    setState(() => loader = true);
    await auth.verifyPhoneNumber(
        phoneNumber: '+91' + phone,
        verificationCompleted: (verificationCompleted) {},
        verificationFailed: (verificationFailed) {},
        codeSent: (verificationId, token) {
          navigatePushReplacement(context,
              OtpVerifyPage(phone: phone, verificationId: verificationId));
          setState(() => loader = false);
        },
        codeAutoRetrievalTimeout: (toe) {});
  }
}
