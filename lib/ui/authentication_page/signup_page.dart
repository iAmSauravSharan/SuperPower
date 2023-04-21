// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/shared/widgets/page_heading.dart';
import 'package:superpower/ui/authentication_page/auth_page.dart';
import 'package:superpower/ui/authentication_page/login_page.dart';
import 'package:superpower/ui/authentication_page/verify_code_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
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
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authentication = AppState.authenticationBloc;

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 450),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IntrinsicHeight(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 36.0, 5, 36),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _getHeadingField(),
                          const SizedBox(height: 45),
                          _getUsernameNameField(),
                          const SizedBox(height: 15),
                          _getEmailField(),
                          const SizedBox(height: 15),
                          _getPasswordField(),
                          const SizedBox(height: 27),
                          _getSignUpButton(),
                          const SizedBox(height: 20),
                          // _signUpUsing(),
                          // const SizedBox(height: 20),
                          // _getGoogleLogin(),
                          const SizedBox(height: 45),
                          _getSignInOption(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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

  Widget _getHeadingField() {
    return const PageHeading(heading: 'Create an account');
  }

  Widget _getUsernameNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: _usernameController,
        cursorColor: Theme.of(context).primaryColor,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username can not be empty';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "Enter username",
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email can not be empty';
          } else if (!EmailValidator.validate(value)) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.email_rounded),
          hintText: "Enter email",
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        ),
      ),
    );
  }

  Widget _getPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        obscureText: _isPasswordHidden,
        controller: _passwordController,
        cursorColor: Theme.of(context).primaryColor,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password cannot be empty';
          } else if (value.length < 6) {
            return 'Password is too short';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password),
          hintText: "Enter password",
          isDense: true,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordHidden
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
            onPressed: _togglePasswordView,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        ),
      ),
    );
  }

  Widget _getSignUpButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton(
          onPressed: signUp,
          child: const Text(
            'Create my account',
          ),
        ),
      ),
    );
  }

  Widget _getSignInOption() => RichText(
        text: TextSpan(
            text: 'Already have an account? ',
            style: Theme.of(context).textTheme.bodySmall,
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => {
                        context
                            .go('${AuthPage.routeName}${LoginPage.routeName}')
                      },
                text: 'Sign in',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ]),
      );

  void signUp() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      snackbar('Invalid value', isError: true);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      ),
    );

    Map<String, Object> arguments = {
      "username": _usernameController.text,
      "sentOn": _emailController.text,
      "verifyingCodeFor": VerifyingCodeFor.user_signup
    };
    _authentication
        .authenticate(
          SignupEvent(_usernameController.text, _emailController.text,
              _passwordController.text),
        )
        .then((value) => {
              Navigator.of(context).pop(),
              GoRouter.of(context).go(
                  '${AuthPage.routeName}${VerifyCodePage.routeName}',
                  extra: (arguments)),
            })
        .catchError((error) => {Navigator.of(context).pop()});

    log.d("reached here.............");
    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  _togglePasswordView() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }
}
