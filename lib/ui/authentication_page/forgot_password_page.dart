import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/shared/widgets/page_heading.dart';
import 'package:superpower/ui/authentication_page/auth_page.dart';
import 'package:superpower/ui/authentication_page/login_page.dart';
import 'package:superpower/ui/authentication_page/reset_password_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('ForgotPasswordPage');

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';
  final String username;

  const ForgotPasswordPage({this.username = '', super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _authentication = AppState.authenticationBloc;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 450),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IntrinsicHeight(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 36, 4, 36),
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
                            const SizedBox(height: 35),
                            _goBackField(),
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

  Widget _goBackField() => GestureDetector(
        onTap: () => {
          GoRouter.of(context)
              .pop((route) => route.settings.name == LoginPage.routeName),
        },
        child: Text(
          'Go back',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      );

  Widget _getEmailField() {
    emailController.setText(widget.username);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        controller: emailController,
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
          contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        ),
      ),
    );
  }

  Widget _getResetPasswordButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton(
          onPressed: resetPassword,
          child: const Text(
            'Reset Password',
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      snackbar('Invalid email', isError: true);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Map<String, Object> arguments = {
      "username": emailController.text,
      "verifyingCodeFor": VerifyingCodeFor.reset_password
    };

    _authentication
        .authenticate(ResetPasswordEvent(
            emailController.text, not_available, not_available))
        .then((value) => {
              Navigator.of(context).pop(),
              GoRouter.of(context).go(
                '${AuthPage.routeName}${ResetPasswordPage.routeName}',
                extra: (arguments),
              ),
            })
        .catchError((error) => {Navigator.of(context).pop()});
  }

  Widget _getHeadingField() {
    return const PageHeading(heading: 'Forgot Password');
  }
}
