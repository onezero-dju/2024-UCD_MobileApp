import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/organization/organization_view_model.dart';
import '../channel/channel_view.dart';

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonSize = screenWidth * 0.15; // 버튼 크기를 동일하게 설정

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
                          return Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: ElevatedButton(
                              onPressed: () {
                                viewModel.selectOrganization(
                                    viewModel.organizations[index]);
                                print(
                                    "Selected Organization: ${viewModel.selectedOrganization}");
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero, // 패딩을 없애고 버튼 크기 고정
                                shape: const CircleBorder(), // 원형 버튼
                                fixedSize:
                                    Size(buttonSize, buttonSize), // 고정 크기 설정
                                backgroundColor:
                                    viewModel.selectedOrganization ==
                                            viewModel.organizations[index]
                                        ? Colors.blue
                                        : Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                    color: Colors.black,
                                    width: screenWidth * 0.005),
                              ),
                              child: Text(
                                viewModel.organizations[index],
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
                          viewModel.showAddOrganizationDialog(context),
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
