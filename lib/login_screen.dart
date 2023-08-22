import 'package:data_spider/logic/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _login(context);
          },
          child: const Text('Нэвтрэх'),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    context.read<LoginProvider>().initiateSignIn(context);
  }
}
