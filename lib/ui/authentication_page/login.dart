import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/main.dart';
import 'package:superpower/shared/widgets/page_heading.dart';
import 'package:superpower/ui/authentication_page/auth.dart';
import 'package:superpower/ui/authentication_page/forgot_password.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 7,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.password),
          hintText: "Enter Password",
        ),
      ),
    );
  }

  Widget _getLoginButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            padding: const EdgeInsets.all(2),
          ),
          icon: Icon(
            Icons.lock_open,
            color: Theme.of(context).primaryColorLight,
            size: 27,
          ),
          label: Text(
            'Sign In',
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          onPressed: signIn,
        ),
      ),
    );
  }

  Widget _getForgotOption() => GestureDetector(
        onTap: () => {
          context.push('${AuthPage.routeName}${ForgotPasswordPage.routeName}')
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blueAccent,
            fontSize: 17,
          ),
        ),
      );

  Widget _getRegisterOption() => RichText(
        text: TextSpan(
          text: 'No Account? ',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 17),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => {context.pop()},
              text: 'Sign Up',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blueAccent,
                fontSize: 17,
              ),
            ),
          ],
        ),
      );

  Future signIn() async {
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

    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: _emailController.text.trim(),
    //     password: _passwordController.text.trim(),
    //   );
    // } on FirebaseAuthException catch (e) {
    //   snackbar(e.message, isError: true);
    // }
    // try {
    //   var user = FirebaseAuth.instance.currentUser;
    //   if (user != null) {
    //     user
    //         .getIdToken(true)
    //         .then((token) => PreferenceManager.saveData(bearerToken, token));
    //   }
    // } on Exception catch (e) {
    //   snackbar(e.toString(), isError: true);
    // }
    log.d("reached here.............");
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
