import 'package:flutter/material.dart';

import '../widgets/circular_border_avatar.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 85,
            ),
            Center(
              child: CircularBorderAvatar(
                'https://i.ibb.co/YjNpQq7/cloudJ.jpg',
                borderColor: Colors.orange,
                size: 175,
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "장현서",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),

            // 키, 체중
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "성별",
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  Text(
                    "키",
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  Text(
                    "체중",
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 1.5, // 선의 두께
                    width: 75, // 선의 길이를 화면 너비만큼 설정
                    color: Colors.black, // 선의 색상
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Container(
                    height: 1.5, // 선의 두께
                    width: 85, // 선의 길이를 화면 너비만큼 설정
                    color: Colors.black, // 선의 색상
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 1.5, // 선의 두께
                    width: 80, // 선의 길이를 화면 너비만큼 설정
                    color: Colors.black, // 선의 색상
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),

            // 평균 케이던스
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "평균 케이던스",
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 1.5,
                    width: 310,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),

            // 최고 기록
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "최고 기록",
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 1.5,
                    width: 310,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
