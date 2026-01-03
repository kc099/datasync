import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final GlobalKey<FormState> _keyL = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: const Icon(Icons.chevron_left, size: 36),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      child: SizedBox(
                        height: 150.0,
                        child: Image.asset('images/logo.jpg'),
                      ),
                    ),
                    Form(
                      key: _keyL,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required Email';
                              }
                              return null;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your email',
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required password';
                              }
                              return null;
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your password',
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                child: Material(
                                  color: const Color(0xf00a1cce),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                  elevation: 5.0,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (_keyL.currentState!.validate()) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          HomePage.id,
                                          (route) => false,
                                        );
                                      }
                                    },
                                    minWidth: 200.0,
                                    height: 42.0,
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
