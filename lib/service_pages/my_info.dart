import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_model.dart';
import '../widgets/circular_border_avatar.dart';
import '../widgets/my_container.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          iconSize: 40,
          color: Colors.black.withAlpha(150),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircularBorderAvatar(
                'https://i.ibb.co/YjNpQq7/cloudJ.jpg', // Assuming the image URL is stored in the UserModel
                borderColor: Colors.orange[500]!,
                size: 175,
              ),
            ),
            const SizedBox(height: 9),
            Center(
              child: Text(
                userModel.identifier, // Display user name
                style: GoogleFonts.nanumGothic(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InfoText(title: "이름", value: userModel.name),
                  const SizedBox(width: 45),
                  InfoText(title: "성별", value: userModel.sex.toUpperCase()),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DividerRow(),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InfoText(title: "키", value: userModel.height.toString()),
                  Text(" cm",
                      style: GoogleFonts.nanumGothic(
                          color: Color.fromARGB(255, 255, 100, 0))),
                  const SizedBox(width: 45),
                  InfoText(title: "체중", value: userModel.weight.toString()),
                  Text(" kg",
                      style: GoogleFonts.nanumGothic(
                          color: Color.fromARGB(255, 255, 100, 0))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DividerRow(),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  InfoText(
                      title: "평균 케이던스",
                      blank: 30,
                      value: userModel.avgCad.toString()),
                  Text(" SPM",
                      style: GoogleFonts.nanumGothic(
                          color: Color.fromARGB(255, 255, 100, 0)))
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DividerRow(),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  if (userModel.footType == 'normal')
                    InfoText(title: "족형", blank: 115, value: '정상발'),
                  if (userModel.footType == 'flat')
                    InfoText(title: "족형", blank: 115, value: '평발'),
                  if (userModel.footType == 'high')
                    InfoText(title: "족형", blank: 115, value: '요족'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DividerRow(),
              ],
            ),
            //
            // 시간 나면 좀 꾸밀 만한 거 추가하자
            // 달성 메달 or 랭크
            //
            const SizedBox(height: 45),
            Center(
              child: MyContainer(
                onPressed: () {
                  print("push 수정하기");
                },
                child: const Text(
                  "내 정보 입력",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Colors.orange[500]!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText(
      {Key? key, required this.title, this.blank, required this.value})
      : super(key: key);

  final String title;
  final String value;
  final double? blank;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.nanumGothic(
              fontSize: 19,
              color: Color.fromARGB(255, 255, 100, 0),
              fontWeight: FontWeight.w500),
        ),
        SizedBox(width: blank ?? 0.0),
        Text(
          "   $value",
          style: GoogleFonts.nanumGothic(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black.withAlpha(180)),
        ),
      ],
    );
  }
}

class DividerRow extends StatelessWidget {
  const DividerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 1.5,
          width: 300,
          color: Colors.black.withAlpha(80),
        ),
      ],
    );
  }
}
