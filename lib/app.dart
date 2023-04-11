import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superpower/bloc/theme/theme_bloc/theme_bloc.dart';
import 'package:superpower/bloc/theme/theme_constants.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final log = Logging("App");

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ThemeBloc(ThemeState(themeManager: AppState.themeManager)),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState state) {
          log.d("Launching App with theme ${state.themeManager.getTheme()}");
          return MaterialApp.router(
            title: "SuperPower⚡",
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: messengerKey,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.themeManager.getTheme(),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

// class LaunchWidget extends StatelessWidget {
//   const LaunchWidget({super.key});

//   @override
//   Widget build(BuildContext context) => const Scaffold(
//         body: HomePage(),
//       );

//   Widget mainApp() => StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return snackbar("Something went wrong", isError: true);
//           } else if (snapshot.hasData) {
//             return const HomePage();
//           } else {
//             return const AuthPage();
//           }
//         },
//       );
// }