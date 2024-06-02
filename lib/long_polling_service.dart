import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'notifications_model.dart'; // 정확한 경로로 수정해야 함

class LongPollingService {
  final String serverUrl;
  final String userId;
  Timer? _timer;
  bool _isRunning = false;
  final NotificationModel notificationModel;

  LongPollingService({
    required this.serverUrl,
    required this.userId,
    required this.notificationModel,
  });

  void startLongPolling() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      if (!_isRunning) {
        timer.cancel();
      } else {
        var response = await http.get(Uri.parse('$serverUrl'));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          notificationModel.addNotification(data); // NotificationModel 업데이트
        } else if (response.statusCode == 204) {
          print("No updates from server");
        }
      }
    });
  }

  void startListening() {
    startLongPolling();
  }

  void stopListening() {
    stopLongPolling();
  }

  void stopLongPolling() {
    _isRunning = false;
    _timer?.cancel();
  }
}
