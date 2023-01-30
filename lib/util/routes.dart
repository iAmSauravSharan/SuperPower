import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/screen/authentication_page/auth.dart';
import 'package:superpower/screen/authentication_page/forgot_password.dart';
import 'package:superpower/screen/authentication_page/login.dart';
import 'package:superpower/screen/authentication_page/signup.dart';
import 'package:superpower/screen/chat_page/chat.dart';
import 'package:superpower/screen/home_page/home.dart';
import 'package:superpower/screen/profile_page/profile_page.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/logging.dart';

final log = Logging('GoRouter');

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: "profile",
          builder: (context, state) => const ProfilePage(),
          redirect: (context, state) {
            if (isLoggedIn()) {
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
          redirect: (context, state) {
            if (isLoggedIn()) {
              return ChatPage.routeName;
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
              builder: (context, state) => const ForgotPasswordPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
