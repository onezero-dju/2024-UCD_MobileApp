import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/models/organization_model.dart';
import 'package:ucd/services/token_service.dart';
import 'package:ucd/views/category/category_view_model.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import 'package:ucd/views/organization/organization_view_model.dart';
import '../channel/channel_view.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    // 처음에만 fetchUserOrganizations 호출되도록 처리
    if (!_isFetching) {
      _isFetching = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final organizationViewModel =
            Provider.of<OrganizationViewModel>(context, listen: false);

        await organizationViewModel.fetchUserOrganizations(context);
        
        // 선택된 조직이 있는 경우 채널 가져오기
        if (organizationViewModel.selectedOrganization != null) {
          final channelViewModel =
              Provider.of<ChannelViewModel>(context, listen: false);
          final selectedOrganization = organizationViewModel.selectedOrganization!;
          final token = await getToken(); // 토큰 가져오기
          if (token != null) {
            channelViewModel.fetchChannels(selectedOrganization.id.toString(), token);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonSize = screenWidth * 0.15; // 버튼 크기를 동일하게 설정

    return Consumer3<OrganizationViewModel, ChannelViewModel, CategoryViewModel>(
      builder: (context, organizationViewModel, channelViewModel, categoryViewModel, child) {
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
                        itemCount: organizationViewModel.organizations.length,
                        itemBuilder: (context, index) {
                          final organization = organizationViewModel.organizations[index];
                          return Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: ElevatedButton(
                              onPressed: () async {
                                print(organization);
                                
                                // 조직 선택 시 기존 채널 초기화
                                channelViewModel.clearSelectedChannel();
                                organizationViewModel.selectOrganization(organization);
                                categoryViewModel.clearSelectedCategory();
                                final token = await getToken();
                                if (token != null) {
                                  await channelViewModel.fetchChannels(
                                    organization.id.toString(), token);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const CircleBorder(),
                                fixedSize: Size(buttonSize, buttonSize),
                                backgroundColor:
                                    organizationViewModel.selectedOrganization ==
                                            organization
                                        ? Colors.blue
                                        : Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                    color: Colors.black,
                                    width: screenWidth * 0.005),
                              ),
                              child: Text(
                                organization.name,
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
                          organizationViewModel.showNoOrganizationsDialog(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        fixedSize: Size(buttonSize, buttonSize),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: BorderSide(
                            color: Colors.black, width: screenWidth * 0.005),
                      ),
                      child: Icon(
                        Icons.add,
                        size: screenWidth * 0.07,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
              // 오른쪽 패널 - ChannelScreen
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