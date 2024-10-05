
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ucd/views/login/login_view.dart';

import 'package:ucd/views/login/sign_up_view.dart';
import 'package:ucd/views/organization/organization_view.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => SignUpView(),
    ),
    GoRoute(
      path: '/organization',
      name: 'organization',
      builder: (context, state) => const OrganizationScreen(),
    ),
  ],
);
