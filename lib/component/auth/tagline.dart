import 'package:flutter/material.dart';

class TagLine extends StatelessWidget {
  const TagLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'tagline',
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/splash_icon.png',
                scale: 5,
              ),
              height: 80,
            ),
            SizedBox(
              width: 10,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Make\n',
                  ),
                  TextSpan(
                    text: 'Up',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              style: TextStyle(
                color: Colors.white,
                height: .9,
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "YOU",
              style: TextStyle(
                fontSize: 80,
                color: Colors.white,
                fontWeight: FontWeight.w100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
