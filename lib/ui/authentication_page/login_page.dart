import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/shared/widgets/page_heading.dart';
import 'package:superpower/ui/authentication_page/auth_page.dart';
import 'package:superpower/ui/authentication_page/forgot_password_page.dart';
import 'package:superpower/ui/home_page/home_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('LoginPage');

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authentication = AppState.authenticationBloc;
  final _repository = AppState.repository;
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 450),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IntrinsicHeight(
                child: Card(
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 36.0, 2, 36),
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _getHeadingField(),
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

  Widget _getHeadingField() {
    return const PageHeading(heading: 'Sign in');
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
            return 'Email cannot be empty';
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
          hintText: "Enter Password",
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

  Widget _getLoginButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton(
          onPressed: signIn,
          child: const Text(
            'Sign in',
          ),
        ),
      ),
    );
  }

  Widget _getForgotOption() => TextButton(
        onPressed: () => {
          GoRouter.of(context).go(
            '${AuthPage.routeName}${ForgotPasswordPage.routeName}',
            // queryParams: {'title': arguments['title'] as String},
            extra: ({'username': none}),
          )
        },
        child: Text(
          'Forgot Password?',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      );

  Widget _getRegisterOption() => RichText(
        text: TextSpan(
          text: 'No Account? ',
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => {context.pop()},
              text: 'Create an account',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      );

  Future signIn() async {
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

    _authentication
        .authenticate(
            LoginEvent(_emailController.text, _passwordController.text))
        .then((value) => {
              log.d("logged in successful..."),
              saveTokens(value),
              _repository.setLoggedInStatus(true),
              Navigator.of(context).pop(),
              GoRouter.of(context)
                  .pop((route) => route.settings.name == HomePage.routeName),
              GoRouter.of(context).go(HomePage.routeName),
            })
        .catchError((error) => {
          log.d("logged in failed...$error"),
          snackbar('Something went wrong', isError: true),
          Navigator.of(context).pop(),
          });

    log.d("logged in finish.............");
  }

  saveTokens(Object value) {
    final response = value as Map<String, dynamic>;
    _repository.saveToken(
        TokenType.idToken, response[TokenType.idToken.name] as String);
    _repository.saveToken(
        TokenType.accessToken, response[TokenType.accessToken.name] as String);
    _repository.saveToken(TokenType.refreshToken,
        response[TokenType.refreshToken.name] as String);
  }

  _togglePasswordView() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }
}
