import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:superpower/ui/home_page/home.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  static String routeName = 'error-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getErrorAnimation(),
            const SizedBox(height: 35),
            _getErrorText(context),
            const SizedBox(height: 35),
            _goBackField(context),
          ],
        ),
      ),
    );
  }

  Widget _getErrorAnimation() {
    return Container(
      constraints: const BoxConstraints(
          maxHeight: 300, maxWidth: 300, minHeight: 200, minWidth: 200),
      child: Lottie.network(
          'https://assets1.lottiefiles.com/packages/lf20_jaN6wbJUkQ.json'),
    );
  }

  Widget _getErrorText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Uhh hoo! I\'m lost, again!',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _goBackField(BuildContext context) => GestureDetector(
        onTap: () => {
          GoRouter.of(context).pop(HomePage.routeName),
        },
        child: Text(
          'Start Over',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
}
