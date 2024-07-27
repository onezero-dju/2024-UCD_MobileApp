import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/user_viewmodel.dart';
import 'views/screens/user_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(),
      child: MaterialApp(
        title: 'MVVM Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const UserView(),
      ),
    );
  }
}
