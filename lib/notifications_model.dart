import 'dart:async';
import 'package:flutter/material.dart';

class NotificationModel extends ChangeNotifier {
  // List<Map<String, dynamic>>을 처리하기 위한 스트림 컨트롤러
  StreamController<List<Map<String, dynamic>>> _notificationStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  List<Map<String, dynamic>> _notifications = [];

  String _lastMessage = "";

  String get lastMessage => _lastMessage;

  Stream<List<Map<String, dynamic>>> get notificationStream =>
      _notificationStreamController.stream;

  void addNotification(Map<String, dynamic> message) {
    _notifications.add(message);
    _notificationStreamController.sink.add(List.from(_notifications));
    _lastMessage = "$message"; // 메시지 객체를 문자열로 변환하여 저장
    print('Notification added: $message');
    // print('Latest message updated to: $lastMessage');
    notifyListeners();
  }

  // 모든 알림을 지우는 메서드
  void clearNotifications() {
    _notifications.clear();
    _notificationStreamController.sink
        .add(List.from(_notifications)); // 변경된 빈 리스트를 스트림에 추가
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationStreamController.close(); // 스트림 컨트롤러를 닫음
    super.dispose();
  }
}
