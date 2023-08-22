import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../home_screen.dart';
import '../logic/login.dart';
import '../login_screen.dart';

class Routes {
  static final router = GoRouter(
      redirect: (context, state) {
        print('redirect====================>');
        var isLoggedIn = context.watch<LoginProvider>().isLoggedIn;
        if (!isLoggedIn) {
          return '/login';
        }
        return '/';
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(
              key: ValueKey('homeScreenKey'),
              child: HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            return const MaterialPage(
              key: ValueKey('loginScreenKey'),
              child: LoginScreen(),
            );
          },
        ),
      ]);
}
