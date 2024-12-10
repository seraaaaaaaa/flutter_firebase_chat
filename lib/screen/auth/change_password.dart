import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screen/auth/widgets/error_box.dart';
import 'package:flutter_firebase/screen/auth/widgets/screen_title.dart';
import 'package:flutter_firebase/screen/auth/widgets/input.dart';
import 'package:flutter_firebase/screen/auth/widgets/password_check.dart';
import 'package:flutter_firebase/service/user_service.dart';
import 'package:flutter_firebase/service/utils.dart';
import 'package:flutter_firebase/themes/constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  final User user;

  const ChangePasswordScreen({
    required this.user,
    super.key,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  String _newPsw = "";
  String _confirmPsw = "";

  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  bool _isPasswordCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _validPsw = false;

  String _errorMsg = "";

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
                  icon: Icons.password,
                  title: 'Change Password',
                  desc: 'Enter your new password.',
                ),
                const SizedBox(
                  height: kPadding,
                ),
                Input(
                  labelText: 'New Password',
                  inputType: 'password',
                  autofocus: true,
                  onSaved: (val) {
                    setState(() {
                      _newPsw = val;
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      _errorMsg = "";
                    });
                    _onPasswordChanged(val);
                  },
                  obscureText: !_isNewVisible,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isNewVisible = !_isNewVisible;
                      });
                    },
                    child: _isNewVisible
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
                Input(
                  labelText: 'Confirm Password',
                  inputType: 'password',
                  onSaved: (val) {
                    setState(() {
                      _confirmPsw = val;
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      _errorMsg = "";
                    });
                  },
                  obscureText: !_isConfirmVisible,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isConfirmVisible = !_isConfirmVisible;
                      });
                    },
                    child: _isConfirmVisible
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
                                _formKey.currentState!.save();

                                showProgressDialog(context);

                                String result = await _userService
                                    .changePassword(_newPsw, _confirmPsw);
                                if (!context.mounted) return;

                                Navigator.pop(context); //pop progress dialog

                                if (result.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text('Password changed successfully'),
                                  ));
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    _errorMsg = result;
                                  });
                                }
                              }
                            },
                      child: const Text('Change Password')),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
