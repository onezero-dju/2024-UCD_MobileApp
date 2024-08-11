import 'package:flutter/material.dart';
import 'package:ucd/models/organization_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class OrganizationViewModel extends ChangeNotifier {
  List<Organization> _organizations = [];
  bool _isLoading = false;

  List<Organization> get organizations => _organizations;
  bool get isLoading => _isLoading;

  Future<void> fetchOrganizations() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(
      Uri.parse('https://your-backend.com/api/organizations'),
      headers: {
        'Authorization': 'Bearer your_jwt_token', // JWT 토큰 헤더에 추가
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _organizations = data.map((json) => Organization.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load organizations');
    }

    _isLoading = false;
    notifyListeners();
  }
}
