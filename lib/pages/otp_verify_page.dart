import 'package:crud/pages/homepage.dart';
import 'package:crud/themes/colors.dart';
import 'package:crud/utils.dart';
import 'package:crud/widgets/theme_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyPage extends StatefulWidget {
  final String phone;
  final String verificationId;

  const OtpVerifyPage(
      {Key? key, required this.phone, required this.verificationId})
      : super(key: key);

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  bool loader = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String otp;

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
              Text(
                'Verify your phone',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              Text(
                'Enter code',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: colorPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 8),
              PinCodeTextField(
                appContext: context,
                keyboardType: TextInputType.number,
                textStyle: Theme.of(context).textTheme.headlineLarge,
                length: 6,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  inactiveColor: colorPrimary,
                  disabledColor: Colors.transparent,
                  errorBorderColor: colorRed,
                  activeColor: colorPrimary,
                  inactiveFillColor: Colors.transparent,
                  selectedColor: colorPrimary,
                  selectedFillColor: colorPrimary,
                  activeFillColor: colorPrimary,
                  borderWidth: 1,
                ),
                showCursor: false,
                animationDuration: const Duration(milliseconds: 300),
                // enableActiveFill: true,
                onChanged: (value) => setState(() => otp = value),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ThemeButton(
                      title: 'VERIFY',
                      loader: loader,
                      onPress: signIn,
                      width: MediaQuery.of(context).size.width / 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    if (otp.length < 6 || loader == true) {
      return;
    } else {
      setState(() => loader = true);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: otp);

      await auth.signInWithCredential(credential).then((value) async {
        navigatePushReplacement(context, const HomePage());
        setState(() => loader = false);
      });
    }
  }
}
