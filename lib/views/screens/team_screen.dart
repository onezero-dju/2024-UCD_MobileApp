import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/viewmodels/oz_view_model.dart';

class TeamListScreen extends StatelessWidget {
  const TeamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final organizationViewModel = Provider.of<OrganizationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 팀 목록'),
      ),
      body: organizationViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: organizationViewModel.organizations.length,
              itemBuilder: (context, index) {
                final organization = organizationViewModel.organizations[index];
                return ListTile(
                  title: Text(organization.name),
                  subtitle: Text('역할: ${organization.role}'),
                  onTap: () {
                    // 팀을 클릭했을 때의 동작
                  },
                );
              },
            ),
    );
  }
}
