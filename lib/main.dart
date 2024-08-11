import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/viewmodels/oz_view_model.dart';
import 'package:ucd/views/screens/team_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrganizationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeamListScreen(),
    );
  }
}
