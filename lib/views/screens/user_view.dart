import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user_viewmodel.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User View')),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          return userViewModel.user == null
              ? const Center(child: CircularProgressIndicator())
              : Center(child: Text('Hello, ${userViewModel.user!.name}'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UserViewModel>().fetchUser('123'),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
