import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/providers/organization_provider.dart';
import 'package:ucd/providers/meeting_note_provider.dart';
import 'package:ucd/providers/category_provider.dart';

import 'package:ucd/views/screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrganizationProvider()),
        ChangeNotifierProvider(create: (_) => MeetingNoteProvider()),
        ChangeNotifierProvider(
            create: (_) => CategoryProvider()), // CategoryProvider 추가
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
