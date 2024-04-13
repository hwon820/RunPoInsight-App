import 'package:flutter/material.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnalysisPage'),
      ),
      body: Center(
        child: Text(
          '분석 결과 조회 페이지 구현 예정임다',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
