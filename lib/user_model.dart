// models/user.dart
import 'dart:convert';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String identifier = '';
  String password = '';
  String name = '';
  double weight = 0.0;
  double height = 0.0;
  String sex = '';
  String footType = '';
  double avgCad = 0.0;
  List<dynamic> datas = [];

  // 데이터 설정 메서드
  void setUser(Map<String, dynamic> userJson) {
    identifier = userJson['identifier'];
    password = userJson['password'];
    name = userJson['name'];
    weight = userJson['weight'];
    height = userJson['height'];
    sex = userJson['sex'];
    footType = userJson['foot_type'];
    avgCad = userJson['avg_cad'];
    datas = userJson['datas'];
    notifyListeners(); // 리스너에게 상태 변경을 알림
  }
}


// class RunData {
//   final double cad;
//   final String date;
//   final String eventName;
//   final String footPos;
//   final String l1Mes;
//   final String l2Mes;
//   final String l3Mes;
//   final String numberImg;
//   final bool overStride;
//   final String pace;
//   final String record;
//   final String rfid;
//   final String runType;
//   final String sMes;
//   final bool shldImb;
//   final String videoUrl;

//   RunData({
//     required this.cad,
//     required this.date,
//     required this.eventName,
//     required this.footPos,
//     required this.l1Mes,
//     required this.l2Mes,
//     required this.l3Mes,
//     required this.numberImg,
//     required this.overStride,
//     required this.pace,
//     required this.record,
//     required this.rfid,
//     required this.runType,
//     required this.sMes,
//     required this.shldImb,
//     required this.videoUrl,
//   });

//   factory RunData.fromJson(Map<String, dynamic> json) {
//     return RunData(
//       cad: json['cad'].toDouble(),
//       date: json['date'],
//       eventName: json['event_name'],
//       footPos: json['foot_pos'],
//       l1Mes: json['l1_mes'],
//       l2Mes: json['l2_mes'],
//       l3Mes: json['l3_mes'],
//       numberImg: json['number_img'],
//       overStride: json['over_stride'].toUpperCase() == 'TRUE',
//       pace: json['pace'],
//       record: json['record'],
//       rfid: json['rfid'],
//       runType: json['run_type'],
//       sMes: json['s_mes'],
//       shldImb: json['shld_imb'].toUpperCase() == 'TRUE',
//       videoUrl: json['video_url'],
//     );
//   }
// }
