import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/organization_model.dart';
import 'package:ucd/views/organization/organization_view_model.dart';
import '../channel/channel_view.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
<<<<<<< HEAD
  bool _isFetching = false;

=======
>>>>>>> f1f35f33a0585c8d24fe232b905f721123d07e4b
  @override
  void initState() {
    super.initState();

<<<<<<< HEAD
    // 처음에만 fetchUserOrganizations 호출되도록 처리
    if (!_isFetching) {
      _isFetching = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<OrganizationViewModel>(context, listen: false)
            .fetchUserOrganizations(context)
            .then((_) {});
      });
    }
=======
    // 로그인 후 받은 JWT 토큰을 여기에 전달하세요.
    const String token = "your_jwt_token_here";

    // 화면이 처음 빌드된 후 ViewModel의 메서드를 호출합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrganizationViewModel>(context, listen: false)
          .fetchUserInfo(token, context);
    });
>>>>>>> f1f35f33a0585c8d24fe232b905f721123d07e4b
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonSize = screenWidth * 0.15; // 버튼 크기를 동일하게 설정
    // 화면이 빌드된 후 fetchUserOrganizations 실행

    return Consumer<OrganizationViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Row(
            children: [
              Container(
                width: screenWidth * 0.2, // 전체 화면의 20%를 차지하도록 설정
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.organizations.length,
                        itemBuilder: (context, index) {
<<<<<<< HEAD
                          final organization = viewModel.organizations[index];
=======
                          // 각 조직의 데이터를 가져옵니다.
                          final organization = viewModel.organizations[index];

>>>>>>> f1f35f33a0585c8d24fe232b905f721123d07e4b
                          return Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: ElevatedButton(
                              onPressed: () {
<<<<<<< HEAD
                                print(organization);
                                viewModel.selectOrganization(organization);
=======
                                // 선택된 조직의 ID를 저장합니다.
                                viewModel.selectOrganization(
                                    organization['organization_id'].toString());
>>>>>>> f1f35f33a0585c8d24fe232b905f721123d07e4b
                                print(
                                    "Selected Organization: ${viewModel.selectedOrganizationId}");
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero, // 패딩을 없애고 버튼 크기 고정
                                shape: const CircleBorder(), // 원형 버튼
                                fixedSize:
                                    Size(buttonSize, buttonSize), // 고정 크기 설정
                                backgroundColor:
<<<<<<< HEAD
                                    viewModel.selectedOrganization ==
                                            organization
=======
                                    viewModel.selectedOrganizationId ==
                                            organization['organization_id']
                                                .toString()
>>>>>>> f1f35f33a0585c8d24fe232b905f721123d07e4b
                                        ? Colors.blue
                                        : Colors.white, // 조직 ID로 배경색 설정
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                    color: Colors.black,
                                    width: screenWidth * 0.005),
                              ),
                              // 버튼 텍스트에 organization_name을 사용합니다.
                              child: Text(
<<<<<<< HEAD
                                organization.name,
=======
                                organization['organization_name'],
>>>>>>> f1f35f33a0585c8d24fe232b905f721123d07e4b
                                style: TextStyle(fontSize: screenWidth * 0.04),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          viewModel.showNoOrganizationsDialog(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // 패딩을 없애고 버튼 크기 고정
                        shape: const CircleBorder(), // 원형 버튼
                        fixedSize: Size(buttonSize, buttonSize), // 고정 크기 설정
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: BorderSide(
                            color: Colors.black, width: screenWidth * 0.005),
                      ),
                      child: Icon(
                        Icons.add,
                        size: screenWidth * 0.07, // 아이콘 크기 비례 설정
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
              // 오른쪽 패널 - 새로운 파일에서 불러오기
              const Expanded(
                child: ChannelScreen(),
              ),
            ],
          ),
        );
      },
    );
  }
}
