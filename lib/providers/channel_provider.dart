// channel_provider.dart
import 'package:flutter/material.dart';

class ChannelProvider with ChangeNotifier {
  Map<String, List<String>> channels = {};
  String? selectedChannel;

  void addNewChannel(String organizationId, String channelName) {
    channels[organizationId] ??= [];
    channels[organizationId]!.add(channelName);
    notifyListeners();
  }

  void selectChannel(String channel) {
    selectedChannel = channel;
    notifyListeners();
  }
}
