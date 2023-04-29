import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/shared/widgets/page_heading.dart';
import 'package:superpower/ui/authentication_page/auth_page.dart';
import 'package:superpower/ui/authentication_page/forgot_password_page.dart';
import 'package:superpower/ui/authentication_page/verify_code_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('ResetPasswordPage');

class ResetPasswordPage extends StatefulWidget {
  static const routeName = '/reset-password';
  final String username;
  final VerifyingCodeFor verifyingCodeFor;

  const ResetPasswordPage(
      {required this.username, required this.verifyingCodeFor, super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  final _authentication = AppState.authenticationBloc;

  @override
  void initState() {
    super.initState();
    log.d('username = ${widget.username}');
    log.d('verifyCodeFor = ${widget.verifyingCodeFor.name}');
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                      padding: const EdgeInsets.fromLTRB(16, 36, 16, 36),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _getHeadingField(),
                            const SizedBox(height: 15),
                            _getPasswordField(),
                            const SizedBox(height: 15),
                            _getConfirmPasswordField(),
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

  Widget _goBackField() => TextButton(
        onPressed: () => {
          GoRouter.of(context).pushReplacement(
              '${AuthPage.routeName}${ForgotPasswordPage.routeName}'),
        },
        child: Text(
          'Go back',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      );

  Widget _getPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Center(
        child: TextFormField(
          controller: passwordController,
          obscureText: _isPasswordHidden,
          cursorColor: Theme.of(context).primaryColor,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (password) {
            if (password == null || password.isEmpty) {
              return 'Enter a valid password';
            } else if (password.length < 6) {
              return 'Password too short';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.password_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordHidden
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
              onPressed: _togglePasswordView,
            ),
            hintText: "Enter Password",
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          ),
        ),
      ),
    );
  }

  Widget _getConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: TextFormField(
        controller: confirmPasswordController,
        obscureText: _isConfirmPasswordHidden,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (password) {
          if (password == null || password.isEmpty) {
            return 'Enter a valid password';
          } else if (password.length < 6) {
            return 'Password too short';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password_rounded),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordHidden
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
            onPressed: _toggleConfirmPasswordView,
          ),
          hintText: "Confirm Password",
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        ),
      ),
    );
  }

  Widget _getResetPasswordButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton(
          onPressed: sendConfirmation,
          child: const Text(
            'Reset Password',
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
  }

  Future sendConfirmation() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      snackbar('Password and confirm Password does not match.', isError: true);
      return;
    }
    Map<String, Object> arguments = {
      "username": widget.username,
      "sentOn": widget.username,
      "password": passwordController.text,
      "verifyingCodeFor": VerifyingCodeFor.reset_password
    };
    log.d('reset password arguments -> ${arguments.toString()}');
    GoRouter.of(context).push(
      '${AuthPage.routeName}${VerifyCodePage.routeName}',
      extra: (arguments),
    );
    return;
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );

    // Map<String, Object> arguments = {
    //   "username": widget.username,
    //   "password": passwordController.text,
    //   "verifyingCodeFor": VerifyingCodeFor.reset_password
    // };

    // _authentication.authRepository
    //     .resetPassword(
    //       ResetPassword(widget.username, none, none, none, none),
    //     )
    //     .then((value) => {
    //           GoRouter.of(context).go(
    //             VerifyCodePage.routeName,
    //             extra: (arguments),
    //           ),
    //         })
    //     .catchError((error) => {
    //           snackbar(error.message, isError: true),
    //           Navigator.of(context).pop()
    //         });
  }

  Widget _getHeadingField() {
    return const PageHeading(heading: 'Reset Password');
  }
}
