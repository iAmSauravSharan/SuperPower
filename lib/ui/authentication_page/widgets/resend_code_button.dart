import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:superpower/bloc/auth/auth_bloc/authentication_bloc.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';

class ResendCodeButton extends StatefulWidget {
  const ResendCodeButton(this.username, this.verifyingCodeFor);

  final VerifyingCodeFor verifyingCodeFor;
  final String username;

  @override
  ResendCodeState createState() => ResendCodeState();
}

class ResendCodeState extends State<ResendCodeButton> {
  TextEditingController textEditingController = TextEditingController();
  final AuthenticationBloc _authenticationBloc = AppState.authenticationBloc;

  final formKey = GlobalKey<FormState>();

  String currentText = "";
  bool hasError = false;
  late Timer _timer;
  int _start = 60;
  bool _isResendAllowed = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: _isResendAllowed
              ? "Didn't receive the code? "
              : 'Resend code in $_start sec',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        TextSpan(
            text: _isResendAllowed ? 'Resend code' : '',
            style: Theme.of(context).textTheme.labelMedium,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _start = 60;
                _isResendAllowed = false;
                startTimer();
                resendVerificationCode();
              }),
      ]),
      textAlign: TextAlign.center,
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isResendAllowed = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future resendVerificationCode() async {
    if (widget.username == null || widget.username.isEmpty) {
      snackbar('Invalid email Id', isError: true);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final event = widget.verifyingCodeFor == VerifyingCodeFor.reset_password
        ? ResetPasswordEvent(widget.username, not_available, not_available)
        : SendCodeEvent(widget.username);

    _authenticationBloc
        .authenticate(event)
        .then((response) => {})
        .catchError((error) => {});

    Navigator.of(context).pop();
  }
}
