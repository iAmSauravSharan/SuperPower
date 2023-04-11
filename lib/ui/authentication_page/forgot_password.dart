import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:superpower/shared/widgets/page_heading.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getHeadingField(),
                      const SizedBox(height: 15),
                      _getEmailField(),
                      const SizedBox(height: 15),
                      _getResetPasswordButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        controller: emailController,
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

  Widget _getResetPasswordButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.lock_open,
            color: Theme.of(context).primaryColorLight,
            size: 27,
          ),
          label: Text(
            'Reset Password',
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          onPressed: resetPassword,
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //TODO: send verification code to email and redirect to verify code screen
    // try {
    //   await FirebaseAuth.instance
    //       .sendPasswordResetEmail(email: emailController.text.trim());
    //   snackbar('Password reset email sent!');
    //   Navigator.of(context).popUntil((route) => route.isFirst);
    // } on FirebaseAuthException catch (e) {
    //   snackbar(e.message, isError: true);
    //   Navigator.of(context).pop();
    // }
  }

  Widget _getHeadingField() {
    return const PageHeading(heading: 'Forgot Password');
  }
}
