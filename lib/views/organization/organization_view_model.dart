import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/organization_model.dart';
import 'package:ucd/services/organization_service.dart';
import 'package:ucd/util/router/token_shared_preferences.dart';

class OrganizationViewModel with ChangeNotifier {
  List<Organization> organizations = []; // 조직 목록
  List<String> searchResults = []; // 검색된 조직 목록
  Organization? selectedOrganization; // 현재 선택된 조직
  final OrganizationService organizationService = OrganizationService();
  List<Map<String, dynamic>> joinRequests = []; // 가입 요청 목록
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
                context.pop();
              },
            ),
            TextButton(
              child: const Text("추가"),
              onPressed: () {
                if (newOrganizationName.isNotEmpty &&
                    newOrganizationDescription.isNotEmpty) {
                  createOrganization(
                      context, newOrganizationName, newOrganizationDescription);
                  context.pop();
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
            return AlertDialog(
              scrollable: true,
              title: const Text('조직 검색'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // `min`을 사용하여 Column 크기를 자식 위젯 크기에 맞게 설정
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          keyword = value; // 입력받은 검색어를 저장
                        });
                      },
                      decoration:
                          const InputDecoration(hintText: '조직 이름을 입력하세요'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (keyword.isNotEmpty) {
                          await Provider.of<OrganizationViewModel>(context,
                                  listen: false)
                              .searchOrganizations(
                                  keyword, 0, 10); // 첫 페이지, 10개 검색
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
                        if (viewModel.searchResults.isEmpty) {
                          return const Text('검색 결과가 없습니다.');
                        } else {
                          return Column(
                            children: [
                              const Text('최근 검색 기록'),
                              SizedBox(
                                height: 200, // 검색 결과 영역에 고정된 높이를 부여
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: viewModel.searchResults
                                        .map((organizationName) {
                                      return ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(organizationName),
                                            ElevatedButton(
                                              onPressed: () {
                                                showJoinOrganizationDialog(
                                                    context, organizationName);
                                              },
                                              child: const Text(
                                                '가입하기',
                                              ),
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop(); // 모달 닫기
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
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

  // 조직 가입 요청 다이얼로그
  void showJoinOrganizationDialog(
      BuildContext context, String organizationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String joinMessage = "";
        return AlertDialog(
          title: Text("$organizationName 가입 요청"),
          content: TextField(
            onChanged: (value) {
              joinMessage = value;
            },
            decoration: const InputDecoration(hintText: "가입 요청 메시지를 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("요청 보내기"),
              onPressed: () {
                if (joinMessage.isNotEmpty) {
                  sendJoinRequest(context, organizationName, joinMessage);
                  Navigator.of(context).pop();
                } else {
                  print("가입 메시지를 입력하세요.");
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 조직 검색 메서드
  Future<void> searchOrganizations(String keyword, int page, int size) async {
    try {
      final token = await getToken(); // 토큰을 가져옴
      print("검색할 때: $token");
      final fetchedData = await organizationService.searchOrganization(
          token!, keyword, page, size);
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

  // 조직 가입 요청 보내기
  Future<void> sendJoinRequest(
      BuildContext context, String organizationName, String message) async {
    try {
      final token = await getToken(); // 토큰을 가져옴
      // 전체 조직을 검색하여 데이터를 가져옴
      final fetchedData = await organizationService.searchOrganization(
          token!, organizationName, 0, 10);

      // 조직 이름이 일치하는 첫 번째 조직 찾기
      final organization = fetchedData
          .firstWhere((org) => org['organization_name'] == organizationName);
      print("조직 가입할 때 organization: $organization");
      final organizationId = organization['organization_id'];

      await organizationService.requestJoinOrganization(
          organizationId, message);
      print('가입 요청을 보냈습니다.');
    } catch (e) {
      print('가입 요청 실패: $e');
    }
  }

  // 조직 가입 요청 목록 조회
  Future<void> fetchJoinRequests(int organizationId) async {
    try {
      final List<dynamic> fetchedRequests =
          await organizationService.getJoinRequests(organizationId);
      joinRequests = fetchedRequests.cast<Map<String, dynamic>>();
      print("joinRequests: $joinRequests");
      notifyListeners();
    } catch (e) {
      print('가입 요청 목록 조회 실패: $e');
    }
  }

  // 가입 요청 승인
  Future<void> approveJoinRequest(int organizationId, int requestId) async {
    try {
      await organizationService.approveJoinRequest(organizationId, requestId);
      print("가입 요청 승인 성공");
      fetchJoinRequests(organizationId); // 요청 목록 갱신
    } catch (e) {
      print("가입 요청 승인 실패: $e");
    }
  }

  // 가입 요청 거절
  Future<void> rejectJoinRequest(int organizationId, int requestId) async {
    try {
      await organizationService.rejectJoinRequest(organizationId, requestId);
      print("가입 요청 거절 성공");
      fetchJoinRequests(organizationId); // 요청 목록 갱신
    } catch (e) {
      print("가입 요청 거절 실패: $e");
    }
  }

  // 새로운 조직을 생성하고 목록을 다시 불러오기
  Future<void> createOrganization(BuildContext context,
      String newOrganizationName, String newOrganizationDescription) async {
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
