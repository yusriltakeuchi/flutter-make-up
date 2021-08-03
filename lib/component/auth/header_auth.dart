import 'package:flutter/material.dart';

class HeaderAuth extends StatelessWidget {
  final String title, desc;
  HeaderAuth({required this.title, required this.desc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'header-auth',
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$title\n",
              style: TextStyle(fontSize: 50),
            ),
            TextSpan(
              text: desc,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
