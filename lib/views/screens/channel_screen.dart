import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ucd/providers/organization_provider.dart';

import 'package:ucd/views/screens/category_screen.dart'; // 새로 추가된 카테고리 화면 import

class ChannelScreen extends StatelessWidget {
  const ChannelScreen({super.key});

  void _addNewChannel(BuildContext context) {
    final provider = Provider.of<OrganizationProvider>(context, listen: false);
    if (provider.selectedOrganization != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String newChannelName = "";
          return AlertDialog(
            title: const Text("새로운 채널 추가"),
            content: TextField(
              onChanged: (value) {
                newChannelName = value;
              },
              decoration: const InputDecoration(hintText: "채널 이름을 입력하세요"),
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
                  if (newChannelName.isNotEmpty) {
                    provider.addNewChannel(newChannelName);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<OrganizationProvider>(
      builder: (context, provider, child) {
        if (provider.selectedOrganization == null) {
          return const Center(child: Text("조직을 선택하세요"));
        } else if (provider.selectedChannel == null) {
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
                      onPressed: () => _addNewChannel(context),
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
                      provider.channels[provider.selectedOrganization]!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          right: screenWidth * 0.2,
                          left: screenWidth * 0.1,
                          top: screenWidth * 0.06),
                      child: ElevatedButton(
                        onPressed: () {
                          provider.selectChannel(provider
                              .channels[provider.selectedOrganization]![index]);
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
                          provider
                              .channels[provider.selectedOrganization]![index],
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
