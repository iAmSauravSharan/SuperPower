import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/shared/widgets/page_heading.dart';
import 'package:superpower/ui/authentication_page/auth_page.dart';
import 'package:superpower/ui/authentication_page/forgot_password_page.dart';
import 'package:superpower/ui/authentication_page/login_page.dart';
import 'package:superpower/ui/authentication_page/widgets/resend_code_button.dart';
import 'package:superpower/ui/home_page/home.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('VerifyCodePage');

class VerifyCodePage extends StatefulWidget {
  static const routeName = '/verify-code';
  final bool isEmailBasedVerification;
  final String sentOn;
  final String username;
  final String password;
  final VerifyingCodeFor verifyingCodeFor;

  const VerifyCodePage(
      {required this.sentOn,
      required this.username,
      required this.verifyingCodeFor,
      this.password = '',
      this.isEmailBasedVerification = true,
      super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late String verificationCode;
  final _authentication = AppState.authenticationBloc;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log.d('sentOn -> ${widget.sentOn}');
    log.d('username -> ${widget.username}');
    log.d('password -> ${widget.password}');
    log.d('verifyingCodeFor -> ${widget.verifyingCodeFor.name}');
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
                            _getOTPDestinationHeading(),
                            const SizedBox(height: 25),
                            _getOTPField(),
                            const SizedBox(height: 25),
                            _getVerifyCodeButton(),
                            const SizedBox(height: 25),
                            _getResendCodeButton(),
                            const SizedBox(height: 25),
                            if (widget.verifyingCodeFor ==
                                VerifyingCodeFor.reset_password)
                              _getChangeOTPDestinationHeading(),
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

  Widget _getChangeOTPDestinationHeading() => GestureDetector(
        onTap: () => {
          GoRouter.of(context).go(
            '${AuthPage.routeName}${ForgotPasswordPage.routeName}',
            // queryParams: {'title': arguments['title'] as String},
            extra: ({'username': widget.sentOn}),
          )
        },
        child: Text(
          widget.isEmailBasedVerification
              ? 'Change email id'
              : 'Change phone number',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      );

  Widget _getOTPDestinationHeading() => Padding(
        padding: const EdgeInsets.all(7),
        child: Text(
          'verification code has been sent on ${widget.sentOn}',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      );

  Widget _getVerifyCodeButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton(
          onPressed: widget.verifyingCodeFor == VerifyingCodeFor.user_signup
              ? confirmUser
              : resetPassword,
          child: const Text(
            'Verify Code',
          ),
        ),
      ),
    );
  }

  Widget _getOTPField() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Invalid code';
        } else if (value.length != 6) {
          return 'Incorrect code';
        } else {
          return null;
        }
      },
      onCompleted: (pin) => {
        setState(
          () => verificationCode = pin,
        )
      },
    );
  }

  Future confirmUser() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      snackbar('Invalid code', isError: true);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    _authentication
        .authenticate(VerifyCodeEvent(widget.username, verificationCode))
        .then((value) => {
              GoRouter.of(context)
                  .pop((route) => route.settings.name == HomePage.routeName),
              GoRouter.of(context).go(
                '${AuthPage.routeName}${LoginPage.routeName}',
              ),
            })
        .catchError((error) => {
              snackbar(error.message, isError: true),
              Navigator.of(context).pop()
            });
  }

  Future resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      snackbar('Invalid code', isError: true);
      return;
    } else if (widget.password == null ||
        widget.password.isEmpty ||
        widget.password.length < 8) {
      snackbar('Invalid password', isError: true);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    _authentication
        .authenticate(ResetPasswordEvent(
            widget.username, widget.password, verificationCode))
        .then((value) => {
              Navigator.of(context).pop(),
              GoRouter.of(context).go(
                '${AuthPage.routeName}${LoginPage.routeName}',
              ),
            })
        .catchError((error) => {Navigator.of(context).pop()});
  }

  Widget _getHeadingField() {
    return const PageHeading(heading: 'Verify Code');
  }

  Widget _getResendCodeButton() {
    return ResendCodeButton(widget.sentOn, widget.verifyingCodeFor);
  }
}
