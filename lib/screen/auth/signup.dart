import 'package:flutter/material.dart';
import 'package:flutter_firebase/screen/auth/widgets/error_box.dart';
import 'package:flutter_firebase/screen/auth/widgets/screen_title.dart';
import 'package:flutter_firebase/screen/auth/widgets/input.dart';
import 'package:flutter_firebase/screen/auth/widgets/password_check.dart';
import 'package:flutter_firebase/service/user_service.dart';
import 'package:flutter_firebase/service/utils.dart';
import 'package:flutter_firebase/themes/constant.dart';

class SignupScreen extends StatefulWidget {
  final String email;

  const SignupScreen({
    required this.email,
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  String _email = "";
  String _name = "";
  String _password = "";

  bool _isVisible = false;
  bool _isPasswordCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _validPsw = false;

  String _errorMsg = "";

  @override
  void initState() {
    super.initState();

    _email = widget.email;
  }

  void _onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordCharacters = false;
      if (password.length >= 6) _isPasswordCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;

      if (_isPasswordCharacters && _hasPasswordOneNumber) _validPsw = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(kPadding),
              child: Column(children: [
                const SizedBox(
                  height: kPadding,
                ),
                const ScreenTitle(
                  icon: Icons.person_add_outlined,
                  title: 'Create Account',
                  desc: 'Enter your details to create account.',
                ),
                Input(
                    labelText: 'Email Address',
                    initialValue: _email,
                    readonly: true,
                    onSaved: (val) {
                      _email = val;
                    }),
                Input(
                    labelText: 'Name',
                    autofocus: true,
                    onSaved: (val) {
                      _name = val;
                    }),
                Input(
                  labelText: 'Password',
                  inputType: 'password',
                  onChanged: (val) => _onPasswordChanged(val),
                  onSaved: (val) {
                    _password = val;
                  },
                  obscureText: !_isVisible,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    child: _isVisible
                        ? const Icon(
                            Icons.visibility,
                            color: kBlackColor,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: kGreyColor,
                          ),
                  ),
                ),
                PasswordCheck(
                    isPasswordCharacters: _isPasswordCharacters,
                    hasPasswordOneNumber: _hasPasswordOneNumber),
                ErrorBox(errorMsg: _errorMsg),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: !_validPsw
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate()) {
                                showProgressDialog(context);

                                _formKey.currentState!.save();

                                String result = await _userService
                                    .createAccount(_email, _password, _name);

                                if (!context.mounted) return;

                                Navigator.pop(context); //pop progress dialog
                                if (result.isEmpty) {
                                  Navigator.pop(context);
                                }

                                setState(() {
                                  _errorMsg = result;
                                });
                              }
                            },
                      child: const Text('Create an Account')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'By proceeding, you agree to our ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor)),
                        TextSpan(text: ' and '),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor)),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
