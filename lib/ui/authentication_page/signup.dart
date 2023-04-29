import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/main.dart';
import 'package:superpower/ui/authentication_page/auth.dart';
import 'package:superpower/ui/authentication_page/login.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';

final log = Logging("Sign up");

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';

  const SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
              const SizedBox(height: 27),
              _getSignUpButton(),
              const SizedBox(height: 20),
              _signUpUsing(),
              // const SizedBox(height: 20),
              // _getGoogleLogin(),
              const SizedBox(height: 65),
              _getSignInOption(),
            ],
          ),
        ),
      ),
    );
  }

  Text _signUpUsing() {
    return const Text(
      'or sign up using',
      style: TextStyle(
        fontSize: 12,
      ),
    );
  }

  Widget _getNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: _nameController,
        cursorColor: Theme.of(context).primaryColor,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (name) =>
            name != null && name.trim().isEmpty ? 'Name cannot be empty' : null,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "Enter Name",
        ),
      ),
    );
  }

  Widget _getEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        controller: _emailController,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => email != null && !EmailValidator.validate(email)
            ? 'Enter a valid email'
            : null,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email_rounded),
          hintText: "Enter email",
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
        cursorColor: Theme.of(context).primaryColor,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            (value != null && value.length < 6) ? 'Min 8 characters' : null,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.password),
          hintText: "Enter Password",
        ),
      ),
    );
  }

  Widget _getSignUpButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton.icon(
          // style: ElevatedButton.styleFrom(
          //   minimumSize: const Size.fromHeight(50),
          //   padding: const EdgeInsets.all(2),
          // ),
          icon: Icon(
            Icons.lock_open,
            color: Theme.of(context).primaryColorLight,
            size: 27,
          ),
          label: Text(
            'Sign Up',
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          onPressed: signUp,
        ),
      ),
    );
  }

  Widget _getSignInOption() => RichText(
        text: TextSpan(
            text: 'Already have an account? ',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 17),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => {
                        context
                            .go('${AuthPage.routeName}${LoginPage.routeName}')
                      },
                text: 'Sign In',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent,
                  fontSize: 17,
                ),
              ),
            ]),
      );

  void signUp() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      ),
    );

    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          )
          .then((value) => {
                FirebaseFirestore.instance
                    .collection('UserData')
                    .doc(value.user?.uid)
                    .set({
                  "email": _emailController.text.trim(),
                  "name": _nameController.text.trim(),
                  "role": "User"
                })
              })
          .catchError((onError) => snackbar(onError.message, isError: true));
    } on FirebaseAuthException catch (e) {
      log.e('Firebase Auth Exception ${e.message}');
      snackbar(e.message, isError: true);
    } catch (e) {
      log.e('Firebase Exception $e');
      snackbar(e.toString(), isError: true);
    }
    log.d("reached here.............");
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
