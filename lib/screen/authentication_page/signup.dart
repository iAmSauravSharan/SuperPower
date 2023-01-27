import 'package:email_validator/email_validator.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:superpower/main.dart';
import 'package:superpower/util/config.dart';

class SignUpPage extends StatefulWidget {
  final Function() onClickSignIn;

  SignUpPage({
    Key? key,
    required this.onClickSignIn,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              _getNameField(),
              const SizedBox(height: 15),
              _getEmailField(),
              const SizedBox(height: 15),
              _getPasswordField(),
              const SizedBox(height: 15),
              _getSignUpButton(),
              const SizedBox(height: 35),
              _getSignInOption(),
              // _getGoogleLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        keyboardType: TextInputType.name,
        autovalidateMode: AutovalidateMode.always,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "Enter Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            gapPadding: 4,
          ),
        ),
      ),
    );
  }

  Widget _getEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => email != null && !EmailValidator.validate(email)
            ? 'Enter a valid email'
            : null,
        decoration: const InputDecoration(
          prefixIcon: const Icon(Icons.email_rounded),
          hintText: "Enter email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            gapPadding: 4,
          ),
        ),
      ),
    );
  }

  Widget _getPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => (value != null && value.length < 6)
            ? 'Min 8 characters'
            : null,
        decoration: const InputDecoration(
          prefixIcon: const Icon(Icons.password),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            gapPadding: 4,
          ),
          labelText: "Enter Password",
        ),
      ),
    );
  }

  Widget _getSignUpButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          padding: const EdgeInsets.all(2),
        ),
        icon: const Icon(
          Icons.lock_open,
          size: 27,
        ),
        label: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 19,
          ),
        ),
        onPressed: signUp,
      ),
    );
  }

  Widget _getSignInOption() => RichText(
        text: TextSpan(text: 'Already have an account?', children: [
          TextSpan(
              recognizer: TapGestureRecognizer()..onTap = widget.onClickSignIn,
              text: 'Sign In',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.onPrimary))
        ]),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      snackbar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
