import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/ui/authentication_page/auth_page.dart';
import 'package:superpower/ui/authentication_page/forgot_password_page.dart';
import 'package:superpower/ui/authentication_page/login_page.dart';
import 'package:superpower/ui/authentication_page/reset_password_page.dart';
import 'package:superpower/ui/authentication_page/signup_page.dart';
import 'package:superpower/ui/authentication_page/verify_code_page.dart';
import 'package:superpower/ui/chat_page/chat_page.dart';
import 'package:superpower/ui/error_page/error_page.dart';
import 'package:superpower/ui/faq_page/faq_page.dart';
import 'package:superpower/ui/feedback_page/feedback_page.dart';
import 'package:superpower/ui/home_page/home.dart';
import 'package:superpower/ui/payment_page/payment_page.dart';
import 'package:superpower/ui/profile_page/profile_page.dart';
import 'package:superpower/ui/settings_page/settings_page.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('GoRouter');

final _repository = AppState.repository;

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: "home",
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: "error-page",
          builder: (context, state) => const ErrorPage(),
        ),
        GoRoute(
          path: "app-settings",
          builder: (context, state) => const SettingPage(),
        ),
        GoRoute(
          path: "feedback",
          builder: (context, state) => const FeedbackPage(),
        ),
        GoRoute(
          path: "faqs",
          builder: (context, state) => const FAQsPage(),
        ),
        GoRoute(
          path: "payment",
          builder: (context, state) => const PaymentPage(),
        ),
        GoRoute(
          path: "profile",
          builder: (context, state) => const ProfilePage(),
          redirect: (context, state) async {
            log.d('logged in status verifying');
            final status = await _repository.isLoggedIn();
            log.d('logged in status is $status');
            if (status) {
              return ProfilePage.routeName;
            } else {
              return AuthPage.routeName;
            }
          },
        ),
        GoRoute(
          path: "chat",
          name: ChatPage.routeName,
          builder: (context, state) {
            Map<String, Object> payload = state.extra as Map<String, Object>;
            return ChatPage(
              title: payload['title'] as String,
              color: payload['color'] as Color,
            );
          },
          redirect: (context, state) async {
            if (await _repository.isLoggedIn()) {
              return ChatPage.routeName;
            } else if (state == null || state.extra == null) {
              return HomePage.routeName;
            } else {
              return AuthPage.routeName;
            }
          },
        ),
        GoRoute(
          path: "authentication",
          builder: (context, state) => const AuthPage(),
          routes: [
            GoRoute(
              path: "login",
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: "signup",
              builder: (context, state) => const SignUpPage(),
            ),
            GoRoute(
              path: "forgot-password",
              name: ForgotPasswordPage.routeName,
              builder: (context, state) {
                if (state == null || state.extra == null) {
                  return const ForgotPasswordPage();
                }
                Map<String, Object> payload =
                    state.extra as Map<String, String>;
                return ForgotPasswordPage(
                  username: payload['username'] as String,
                );
              },
            ),
            GoRoute(
              path: "verify-code",
              name: VerifyCodePage.routeName,
              builder: (context, state) {
                Map<String, Object> payload =
                    state.extra as Map<String, Object>;
                String password = (payload.containsKey('password'))
                    ? payload['password'] as String
                    : '';
                return VerifyCodePage(
                  sentOn: payload['sentOn'] as String,
                  username: payload['username'] as String,
                  verifyingCodeFor:
                      payload['verifyingCodeFor'] as VerifyingCodeFor,
                  password: password,
                );
              },
              redirect: (context, state) {
                if (state == null || state.extra == null) {
                  return '${AuthPage.routeName}${LoginPage.routeName}';
                }
              },
            ),
            GoRoute(
              path: "reset-password",
              name: ResetPasswordPage.routeName,
              builder: (context, state) {
                Map<String, Object> payload =
                    state.extra as Map<String, Object>;
                return ResetPasswordPage(
                  username: payload['username'] as String,
                  verifyingCodeFor:
                      payload['verifyingCodeFor'] as VerifyingCodeFor,
                );
              },
              redirect: (context, state) {
                if (state == null || state.extra == null) {
                  return '${AuthPage.routeName}${ForgotPasswordPage.routeName}';
                }
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

Widget errorPage() {
  return const ErrorPage();
}
