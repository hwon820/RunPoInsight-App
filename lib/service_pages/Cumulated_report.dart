import 'package:flutter/material.dart';

class CumulReport extends StatelessWidget {
  const CumulReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CumulReport Page'),
      ),
      body: Center(
        child: Text(
          '누적 기록 페이지 구현 예정임다',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
