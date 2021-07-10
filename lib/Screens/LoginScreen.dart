import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_task_coffer/Screens/HomeScreen.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isValid = false;

  bool trySubmitted = false;
  bool otpState = false;

  late String number;

  late String verificationId;

  final auth = FirebaseAuth.instance;

  final TextEditingController _textField = TextEditingController();

  isValueValid(number) {
    if ((otpState && number.length == 6) ||
        (!otpState && number.length == 10)) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  Future<void> _trySubmit() async {
    if (otpState) {
      try {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: _textField.text);

        final _auth = FirebaseAuth.instance;
        final authCredential =
            await _auth.signInWithCredential(phoneAuthCredential);

        if (authCredential.user != null) {
          print(authCredential.user!.uid);
          SharedPreferences _loginData = await SharedPreferences.getInstance();
          _loginData.setString('uid', authCredential.user!.uid);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authCredential.user!.uid)
              .set({
            'userpic':
                'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
          });

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } on FirebaseException catch (err) {
        var message = 'An error occured, Please check your credentials';

        if (err.message != null) {
          message = err.message!;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    } else {
      number = _textField.text;

      try {
        sendOTP();
        setState(() {
          otpState = true;
          isValid = false;
        });
        FocusManager.instance.primaryFocus?.unfocus();
      } catch (error) {
        String message = 'Could not authenticate you. Please try again later.';
        message = error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    }
  }

  sendOTP() async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+91${number}',
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {});
      },
      verificationFailed: (verificationFailed) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verificationFailed.message!),
          ),
        );
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          otpState = true;
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.network(
                    'https://cdn.logo.com/hotlink-ok/logo-social.png'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                TextFormField(
                  controller: _textField,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: otpState ? 'Enter OTP' : 'Phone'),
                  cursorColor: Color(0xff2D5C78),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {},
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    isValueValid(value);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                if (otpState)
                  Center(
                    child: MaterialButton(
                      onPressed: () {
                        sendOTP();
                      },
                      child: Text('Did not get OTP,resend?'),
                    ),
                  ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary:
                            isValid ? Color(0xffE49D70) : Color(0xffD5D7D8),
                        shape: StadiumBorder(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                isValid ? Color(0xFF111212) : Color(0xffA3A5A6),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _trySubmit();
                        _textField.text = '';
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
