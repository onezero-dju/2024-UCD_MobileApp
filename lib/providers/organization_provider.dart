import 'package:flutter/material.dart';

class OrganizationProvider with ChangeNotifier {
  List<String> organizations = [];
  Map<String, List<String>> channels = {};
  String? selectedOrganization;

  void addNewOrganization(String newOrganizationName) {
    organizations.add(newOrganizationName);
    channels[newOrganizationName] = [];
    notifyListeners();
  }

  void addNewChannel(String channelName) {
    if (selectedOrganization != null) {
      channels[selectedOrganization]!.add(channelName);
      notifyListeners();
    }
  }

  void selectOrganization(String organization) {
    selectedOrganization = organization;
    notifyListeners();
  }
}
