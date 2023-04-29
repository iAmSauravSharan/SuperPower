import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:superpower/ui/authentication_page/login.dart';
import 'package:superpower/ui/authentication_page/signup.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/network_connectivity.dart';

final log = Logging('AuthPage');

class AuthPage extends StatefulWidget {
  static const routeName = '/authentication';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String connectivityMessage = '';
  bool isConnectedToInternet = true;
  bool connectionWasBrokenEarlier = false;

  @override
  void initState() {
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      log.d('source $_source');

      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          connectivityMessage = 'Internet connected successfully!';
          isConnectedToInternet = true;
          break;
        case ConnectivityResult.wifi:
          connectivityMessage = 'Internet connected successfully!';
          isConnectedToInternet = true;
          break;
        case ConnectivityResult.none:
        default:
          connectivityMessage = 'No active internet connection';
          connectionWasBrokenEarlier = true;
          isConnectedToInternet = false;
          break;
      }
      if (connectionWasBrokenEarlier) {
        snackbar(connectivityMessage,
            isError: !isConnectedToInternet,
            isInfo: isConnectedToInternet,
            durationInSec: isConnectedToInternet ? 3 : 5);
        if (isConnectedToInternet) {
          connectionWasBrokenEarlier = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: (_isLogin ? const LoginPage() : const SignUpPage()),
      );
}
