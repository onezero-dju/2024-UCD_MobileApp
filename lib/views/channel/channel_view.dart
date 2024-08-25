import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/views/channel/channel_view_model.dart';
import 'package:ucd/views/category/category_view.dart';
import 'package:ucd/views/organization/organization_view_model.dart';

class ChannelScreen extends StatelessWidget {
  const ChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Consumer2<OrganizationViewModel, ChannelViewModel>(
      builder: (context, organizationProvider, channelProvider, child) {
        final organizationId = organizationProvider.selectedOrganization;

        if (organizationId == null) {
          return const Center(child: Text("조직을 선택하세요"));
        } else if (channelProvider.selectedChannel == null ||
            channelProvider.selectedOrganizationId != organizationId) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '회의실',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () => channelProvider.showAddChannelDialog(
                          context, organizationId),
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
                  itemCount:
                      channelProvider.channels[organizationId]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final channel =
                        channelProvider.channels[organizationId]![index];
                    return Padding(
                      padding: EdgeInsets.only(
                          right: screenWidth * 0.2,
                          left: screenWidth * 0.1,
                          top: screenWidth * 0.06),
                      child: ElevatedButton(
                        onPressed: () {
                          channelProvider.selectChannel(
                              organizationId, channel);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          fixedSize:
                              Size(screenWidth * 0.2, screenHeight * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(
                            color: Colors.black,
                            width: screenWidth * 0.005,
                          ),
                        ),
                        child: Text(
                          channel,
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
          // 채널이 선택된 경우 카테고리 화면을 표시합니다.
          return const CategoryScreen();
        }
      },
    );
  }
}
