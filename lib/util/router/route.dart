
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ucd/models/category_model.dart';
import 'package:ucd/views/category/category_view.dart';
import 'package:ucd/views/channel/channel_view.dart';
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
      GoRoute(
      path: '/channel',
      name: 'channel',
      builder: (context, state) => const ChannelScreen(),
    ),
      GoRoute(
      path: '/category',
      name: 'category',
      builder: (context, state) => CategoryView(),
    ),
  ],
);
