import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/category/category_view_model.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import 'package:ucd/views/login/login_view_model.dart';
import 'package:ucd/views/login/sign_up_view_model.dart';
import 'package:ucd/views/meeting_note/meeting_note_view_model.dart';
import 'package:ucd/views/organization/organization_view_model.dart';
import 'util/router/route.dart';  // router.dart 파일을 import


void main() {
  runApp(
    MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => OrganizationViewModel()),
        ChangeNotifierProvider(create: (_) => MeetingNoteViewModel()),
        ChangeNotifierProvider(
            create: (_) => CategoryViewModel()), // CategoryProvider 추가
        ChangeNotifierProvider(create: (_) => ChannelViewModel()), // Cat
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
 Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Schyler'),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider, // 추가
    );
  }
}