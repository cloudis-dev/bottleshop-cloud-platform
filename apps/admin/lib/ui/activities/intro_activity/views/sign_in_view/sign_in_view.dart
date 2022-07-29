import 'package:bottleshop_admin/ui/activities/intro_activity/views/sign_in_view/widgets/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'widgets/dev_login_button.dart';
import 'widgets/error_text.dart';

class SignInView extends HookWidget {
  SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _emailTextFieldCtrl = useTextEditingController();
    final _passwordTextFieldCtrl = useTextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ErrorText(),
              TextField(
                controller: _emailTextFieldCtrl,
                autocorrect: true,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  controller: _passwordTextFieldCtrl,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Heslo'),
                ),
              ),
              SignInButton(
                emailCtrl: _emailTextFieldCtrl,
                passwordCtrl: _passwordTextFieldCtrl,
              ),
              const DevLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
