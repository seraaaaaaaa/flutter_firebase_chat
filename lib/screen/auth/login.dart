import 'package:flutter/material.dart';
import 'package:flutter_firebase/screen/auth/widgets/error_box.dart';
import 'package:flutter_firebase/screen/auth/widgets/screen_title.dart';
import 'package:flutter_firebase/screen/auth/widgets/input.dart';
import 'package:flutter_firebase/service/user_service.dart';
import 'package:flutter_firebase/service/utils.dart';
import 'package:flutter_firebase/themes/constant.dart';

class LoginScreen extends StatefulWidget {
  final String email;

  const LoginScreen({
    required this.email,
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  String _email = "";
  String _password = "";
  bool _isVisible = false;
  String _errorMsg = "";

  @override
  void initState() {
    super.initState();

    _email = widget.email;
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
                  icon: Icons.person,
                  title: 'Log In',
                  desc: 'Enter your password to proceed.',
                ),
                const SizedBox(
                  height: kPadding,
                ),
                Input(
                  labelText: 'Email Address',
                  initialValue: _email,
                  readonly: true,
                ),
                Input(
                  labelText: 'Password',
                  inputType: 'password',
                  autofocus: true,
                  onSaved: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      _errorMsg = "";
                    });
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
                ErrorBox(errorMsg: _errorMsg),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          showProgressDialog(context);
                          _formKey.currentState!.save();

                          String result =
                              await _userService.login(_email, _password);

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
                      child: const Text('Log In')),
                ),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      String result = await _userService.loginWithLink(_email);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(result),
                      ));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Login with a email link instead',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: kPrimaryColor),
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
