import 'package:flutter/material.dart';
import 'package:flutter_firebase/screen/auth/widgets/error_box.dart';
import 'package:flutter_firebase/screen/auth/widgets/screen_title.dart';
import 'package:flutter_firebase/screen/auth/widgets/input.dart';
import 'package:flutter_firebase/screen/auth/login.dart';
import 'package:flutter_firebase/screen/auth/signup.dart';
import 'package:flutter_firebase/service/user_service.dart';
import 'package:flutter_firebase/service/utils.dart';
import 'package:flutter_firebase/themes/constant.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _email = "";
  String _errorMsg = "";

  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              children: [
                const ScreenTitle(
                  icon: Icons.group,
                  title: 'Welcome',
                  desc: 'Enter your email address to proceed.',
                  canPop: false,
                ),
                Input(
                    labelText: 'Email Address',
                    inputType: 'email',
                    onChanged: (val) {
                      setState(() {
                        _email = val;
                        _errorMsg = '';
                      });
                    }),
                ErrorBox(errorMsg: _errorMsg),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: kPadding, horizontal: 6),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        if (_email.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_email)) {
                          setState(() {
                            _errorMsg = 'Please enter a valid email';
                          });

                          return;
                        }

                        showProgressDialog(context);

                        bool isNewEmail = await _userService.isNewEmail(_email);

                        if (!context.mounted) return;

                        Navigator.pop(context); //pop progress dialog

                        if (isNewEmail) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupScreen(
                                    email: _email,
                                  )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    email: _email,
                                  )));
                        }
                      },
                      child: const Text('Continue')),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      color: kGreyColor.shade300,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        " OR ",
                        style: TextStyle(
                          color: kGreyColor.shade300,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      color: kGreyColor.shade300,
                    )),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: kPadding, horizontal: 6),
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () async {
                        await _userService.loginAsGuest();
                      },
                      child: const Text('Continue as Guest')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
