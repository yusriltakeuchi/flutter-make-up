import 'package:flutter/material.dart';

import 'const.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 2,
      valueColor: AlwaysStoppedAnimation<Color>(
        SECONDARY_COLOR.withOpacity(.8),
      ),
      backgroundColor: Colors.white,
    );
  }
}
