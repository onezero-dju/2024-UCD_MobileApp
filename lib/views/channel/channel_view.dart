import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/repository/token.dart';
import 'package:ucd/services/token_service.dart';
import 'package:ucd/views/category/category_view.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import '../organization/organization_view_model.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {

  bool _isFetching = false;
  
 @override
  void initState() {
    super.initState();
    // 처음에만 fetchChannels 호출되도록 처리
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFetching) {
        _isFetching = true;

        // 현재 선택된 조직 가져오기
        final selectedOrganization =
            Provider.of<OrganizationViewModel>(context, listen: false)
                .selectedOrganization;
          
        if (selectedOrganization != null) {
          // 토큰을 비동기적으로 가져오기
          final token = await getToken();
      print(token);
          if (token != null) {
            // 채널 정보를 가져오기
            await Provider.of<ChannelViewModel>(context, listen: false)
                .fetchChannels(selectedOrganization.id.toString(), token);
          }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Consumer2<OrganizationViewModel, ChannelViewModel>(
      builder: (context, organizationProvider, channelProvider, child) {
        final selectedOrganization = organizationProvider.selectedOrganization;

        if (selectedOrganization == null) {
          return const Center(child: Text("조직을 선택하세요"));
        } else if (channelProvider.selectedChannel == null ){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 선택된 조직의 이름을 표시 (null 여부 확인)
                    Text(
                      selectedOrganization.name ?? "조직 이름 없음",  // name이 null일 경우 대비
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              
                    IconButton(
                      onPressed: () => channelProvider.showAddChannelDialog(
                          context, selectedOrganization.id),
                      icon: Icon(
                        Icons.add,
                        size: screenWidth * 0.07,
                      ),
                      color: Colors.black,
                      iconSize: screenWidth * 0.07,
                      splashColor: Colors.grey.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Expanded(
                child: ListView.builder(
                  itemCount: channelProvider.channels[selectedOrganization.id.toString()]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final channel = channelProvider.channels[selectedOrganization.id.toString()]![index];
                    print(channel);
                    return Padding(
                      padding: EdgeInsets.only(
                          right: screenWidth * 0.2,
                          left: screenWidth * 0.1,
                          top: screenWidth * 0.06),
                      child: ElevatedButton(
                        onPressed: () {
                          channelProvider.selectChannel(
                              selectedOrganization.id, channel['channel_id'], channel['name']);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          fixedSize:
                              Size(screenWidth * 0.2, screenHeight * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor:
                              channelProvider.selectedChannel == channel['name']
                                  ? Colors.blue
                                  : Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(
                            color: Colors.black,
                            width: screenWidth * 0.005,
                          ),
                        ),
                        child: Text(
                          channel['name'],
                          style: TextStyle(fontSize: screenWidth * 0.05),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          );
        } else {
          
       return CategoryView();
        }
      },
    );
  }
}
