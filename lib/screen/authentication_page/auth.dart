import 'package:flutter/src/widgets/framework.dart';
import 'package:superpower/screen/authentication_page/login.dart';
import 'package:superpower/screen/authentication_page/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = false;

  @override
  Widget build(BuildContext context) => _isLogin
      ? LoginPage(onClickSignUp: toggle)
      : SignUpPage(onClickSignIn: toggle);

  void toggle() => setState(() => _isLogin = !_isLogin);
}
