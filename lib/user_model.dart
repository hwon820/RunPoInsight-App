// models/user.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../utils.dart';

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

  // Future<void> sendDataToServer(Map<String, dynamic> data) async {
  //   var url = Uri.parse('http://192.168.0.13:5000/users');
  //   var response = await http.post(url,
  //       headers: {'Content-Type': 'application/json'}, body: json.encode(data));

  //   if (response.statusCode == 200) {
  //     print("Data successfully sent to server");
  //   } else {
  //     print("Failed to send data to server: ${response.statusCode}");
  //   }
  // }

  Future<void> updateRunDetails(
      String baseUrl, int userId, Map<String, dynamic> runDetails) async {
    var url = Uri.parse('$baseUrl/$userId/update_runs');
    var response = await http.patch(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(runDetails));

    if (response.statusCode == 200) {
      print("Runs updated successfully");
    } else {
      print("Failed to update runs: ${response.statusCode}, ${response.body}");
    }
  }

  void updateMarathonDetails(
      String name, String date, Map<String, dynamic> newDetails) {
    // 로그인된 사용자의 데이터만 찾아 업데이트
    if (this.name == name) {
      int index = datas.indexWhere((data) => data['date'] == date);
      if (index != -1) {
        datas[index] = {...datas[index], ...newDetails};
        notifyListeners();
        print("Updated data for $name on $date: ${datas[index]}");
      } else {
        print("No record found with the specified date for $name");
      }
    } else {
      print(
          "Trying to update data for identifier: $identifier, current object identifier: ${this.identifier}");
    }
  }
}
