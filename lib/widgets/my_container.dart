import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({
    Key? key,
    required this.child,

    // Box colors
    this.color,
    this.gradient,
    this.borderRadius,
    this.onPressed, // 페이지 이동 함수를 정의하는 콜백
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Gradient? gradient;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // onTap에서 onPressed 콜백을 사용
      child: Container(
        padding: EdgeInsets.all(16),
        child: child,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          color: color ?? Color.fromARGB(255, 235, 235, 235),
          gradient: gradient,

          // my_container 1번
        ),
      ),
    );
  }
}
