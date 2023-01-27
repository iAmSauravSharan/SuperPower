import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:superpower/main.dart';
import 'package:superpower/screen/authentication_page/forgot_password.dart';
import 'package:superpower/util/config.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickSignUp;

  const LoginPage({
    Key? key,
    required this.onClickSignUp,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            _getEmailField(),
            const SizedBox(height: 15),
            _getPasswordField(),
            const SizedBox(height: 15),
            _getLoginButton(),
            const SizedBox(height: 35),
            _getForgotOption(),
            const SizedBox(height: 35),
            _getRegisterOption(),
            // _getGoogleLogin(),
          ],
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
        autovalidateMode: AutovalidateMode.always,
        textInputAction: TextInputAction.next,
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

  Widget _getLoginButton() {
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
          'Sign In',
          style: TextStyle(
            fontSize: 19,
          ),
        ),
        onPressed: signIn,
      ),
    );
  }

  Widget _getForgotOption() => GestureDetector(
        onTap: () => {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()))
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue.shade700,
            fontSize: 20,
          ),
        ),
      );

  Widget _getRegisterOption() => RichText(
        text: TextSpan(
          text: 'No Account? ',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black45,
          ),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = widget.onClickSignUp,
              text: 'Sign Up',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  color: Colors.blue.shade700),
            ),
          ],
        ),
      );

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      snackbar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
