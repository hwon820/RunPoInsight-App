import 'package:flutter/material.dart';

// 프로필 사진용. 아직까지 큰 의미는 X
class CircularBorderAvatar extends StatelessWidget {
  const CircularBorderAvatar(this.image,
      {Key? key, this.size = 32, required this.borderColor})
      : super(key: key);
  final String image;
  final double size;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          backgroundBlendMode: BlendMode.clear,
          border: Border.all(color: borderColor, width: 3),
          image: DecorationImage(image: NetworkImage(image))),
      width: size,
      height: size,
    );
  }
}
