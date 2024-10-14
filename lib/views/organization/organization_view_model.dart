import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/organization_model.dart';
import 'package:ucd/services/organization_service.dart';
import 'package:ucd/services/token_service.dart';

class OrganizationViewModel with ChangeNotifier {
  List<Organization> organizations = []; // 조직 목록
 List<String> searchResults = []; // 검색된 조직 목록// 검색된 조직 목록
  Organization? selectedOrganization; // 현재 선택된 조직
  final OrganizationService organizationService = OrganizationService();

  // 사용자의 조직 정보 가져오기
  Future<void> fetchUserOrganizations(BuildContext context) async {
    try {
      final token = await getToken();
      print("fetch했을 때 token 값: $token");
      final List<dynamic> fetchedData =
          await organizationService.fetchOrganizations(token!);
          print(fetchedData);
      organizations =
          fetchedData.map((data) => Organization.fromJson(data)).toList();
  
      if (organizations.isNotEmpty) {
        selectOrganization(organizations.first); // 첫 번째 조직을 기본값으로 선택
      } else {
        showNoOrganizationsDialog(context); // 조직이 없을 경우 모달 띄우기
      }
      notifyListeners();
    } catch (e) {
      print('Errord: $e');
    }
  }

  // 조직이 없을 때 모달 창 띄우기
  void showNoOrganizationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            '조직을 생성하거나 참여하세요.',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showAddOrganizationDialog(context);
                  },
                  child: const Text('조직 생성'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showSearchOrganizationsDialog(context); // 조직 검색 모달 창 띄우기
                  },
                  child: const Text('조직 참여'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 새로운 조직 추가 다이얼로그
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
                  print("모든 필드를 채워주세요.");
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 조직 검색 다이얼로그
  // OrganizationViewModel에서 showSearchOrganizationsDialog 메서드 추가 또는 수정
void showSearchOrganizationsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String keyword = ""; // 검색어 변수
      return StatefulBuilder(
        builder: (context, setState) {
          return Expanded(
            child: AlertDialog(
              scrollable: true,
              title: const Text('조직 검색'),
              content: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        keyword = value; // 입력받은 검색어를 저장
                      });
                    },
                    decoration: const InputDecoration(hintText: '조직 이름을 입력하세요'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (keyword.isNotEmpty) {
                        await searchOrganizations(keyword, 0, 10); // 첫 페이지, 10개 검색
                        if (context.mounted) {
                          setState(() {}); // 상태 업데이트
                        }
                      }
                    },
                    child: const Text('검색'),
                  ),
                  const SizedBox(height: 16),
                  Consumer<OrganizationViewModel>(
                    builder: (context, viewModel, child) {
                      if (keyword.isNotEmpty) {
                        print(keyword);
                        print(viewModel.searchResults);
                        return const Text('검색 결과가 없습니다.');
                      } else {
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: viewModel.searchResults.length,
                          itemBuilder: (context, index) {
                            final organizationName = viewModel.searchResults[index];
                            return ListTile(
                              title: Text(organizationName),
                              onTap: () {
                                Navigator.of(context).pop(); // 모달 닫기
                              },
                            );
                          },
                        );
                      } 
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
            ),
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
      print("검색할 때: $token");
      final fetchedData = await organizationService.searchOrganization(token!, keyword, page, size);
      print("fetchedData: $fetchedData");
 
     searchResults = fetchedData
        .map((data) => data['organization_name'] as String)
        .toList();
     
      print(searchResults);
      notifyListeners(); // UI 갱신
    } catch (e) {
      print('조직 검색 실패: $e');
    }
  }




  // 새로운 조직을 생성하고 목록을 다시 불러오기
  Future<void> createOrganization(
      BuildContext context,
      String newOrganizationName,
      String newOrganizationDescription) async {
    try {
      final token = await getToken();
      print(token);
      await organizationService.createOrganizations(
          token!, newOrganizationName, newOrganizationDescription);
      await fetchUserOrganizations(context);
    } catch (e) {
      print('조직 생성 실패: $e');
    }
  }

  void selectOrganization(Organization organization) {
    selectedOrganization = organization;
    notifyListeners();
  }
}