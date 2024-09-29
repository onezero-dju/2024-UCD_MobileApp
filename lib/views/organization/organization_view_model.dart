import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/organization_model.dart';
import 'package:ucd/services/organization_service.dart';
import 'package:ucd/services/token_service.dart';

class OrganizationViewModel with ChangeNotifier {
  List<Organization> organizations = []; // 조직 목록
  List<String> organizationNames = []; // 검색된 조직 이름 목록
  Organization? selectedOrganization; // 현재 선택된 조직
  final OrganizationService organizationService = OrganizationService();

  // 사용자의 조직 정보 가져오기
  // 사용자의 조직 정보 가져오기
  Future<void> fetchUserOrganizations(BuildContext context) async {
    try {
      final token = await getToken();
      final List<dynamic> fetchedData =
          await organizationService.fetchOrganizations(token as String);
      organizations =
          fetchedData.map((data) => Organization.fromJson(data)).toList();

      if (organizations.isNotEmpty) {
        selectOrganization(organizations.first); // 첫 번째 조직을 기본값으로 선택
      } else {
        showNoOrganizationsDialog(context); // 조직이 없을 경우 모달 띄우기
      }
      notifyListeners();
    } catch (e) {
      print('Erroddddr: $e');
    }
  }

  // 조직이 없을 때 모달 창 띄우기
  void showNoOrganizationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('조직이 없습니다'),
          content: const Text('조직을 생성하거나 참여하세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showAddOrganizationDialog(context);
              },
              child: const Text('조직 생성'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSearchOrganizationsDialog(context); // 조직 검색 모달 창 띄우기
                // 조직 참여 로직 추가
              },
              child: const Text('조직 참여'),
            ),
          ],
        );
      },
    );
  }

  // 새로운 조직 추가 및 다이얼로그 로직을 함께 처리
  void showAddOrganizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newOrganizationName = "";
        String newOrganizationDescription = "";
        return AlertDialog(
          title: const Text("새로운 조직 추가"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newOrganizationName = value;
                },
                decoration: const InputDecoration(hintText: "조직 이름을 입력하세요"),
              ),
              TextField(
                onChanged: (value) {
                  newOrganizationDescription = value;
                },
                decoration: const InputDecoration(hintText: "조직에 대한 설명을 입력하세요"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("추가"),
              onPressed: () {
                if (newOrganizationName.isNotEmpty &&
                    newOrganizationDescription.isNotEmpty) {
                  createOrganization(
                      context, newOrganizationName, newOrganizationDescription);
                  Navigator.of(context).pop();
                } else {
                  print("다 채워");
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 조직 검색
  void _showSearchOrganizationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String keyword = ""; // 검색어 변수
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('조직 검색'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      keyword = value; // 입력받은 검색어를 저장
                    },
                    decoration: const InputDecoration(hintText: '조직 이름을 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (keyword.isNotEmpty) {
                        // 검색어가 입력된 경우 검색 실행
                        Provider.of<OrganizationViewModel>(context,
                                listen: false)
                            .searchOrganizations(
                                keyword, 0, 10); // 첫 페이지, 10개 검색
                        setState(() {}); // 상태 업데이트
                      }
                    },
                    child: const Text('검색'),
                  ),
                  const SizedBox(height: 16),
                  Consumer<OrganizationViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.organizationNames.isEmpty) {
                        return const Text('검색 결과가 없습니다.');
                      }
                      return ListView.builder(
                        shrinkWrap: true, // 모달 창 크기에 맞춰 사이즈 조정
                        itemCount: viewModel.organizationNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(viewModel.organizationNames[index]),
                            onTap: () {
                              // 조직 선택 시의 로직
                              viewModel.selectOrganization(viewModel
                                  .organizationNames[index] as Organization);
                              Navigator.of(context).pop(); // 모달 닫기
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 조직 검색 메서드
  Future<void> searchOrganizations(String keyword, int page, int size) async {
    try {
      final token = await getToken(); // 토큰을 가져옴
      print(token);
      organizationNames = await organizationService.searchOrganization(
          token as String, keyword, page, size); // 검색 수행

      notifyListeners(); // UI 갱신
    } catch (e) {
      print('조직 검색 실패: $e');
    }
  }

  // 새로운 조직을 생성하고 목록을 다시 불러오기
  Future<void> createOrganization(
      BuildContext context, // BuildContext를 매개변수로 받습니다.
      String newOrganizationName,
      String newOrganizationDescription) async {
    // 토큰을 가져오기
    final token = await getToken();

    // OrganizationService의 createOrganizations에 이름과 설명 전달
    await organizationService.createOrganizations(
        token as String, newOrganizationName, newOrganizationDescription);

    // 조직 목록 다시 불러오기 - context를 올바르게 전달
    await fetchUserOrganizations(context);
  }

  void selectOrganization(Organization organization) {
    selectedOrganization = organization; // 조직 이름을 선택된 값으로 설정
    notifyListeners();
  }
}
