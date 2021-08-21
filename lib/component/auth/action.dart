import 'package:flutter/material.dart';

class ActionAuth extends StatelessWidget {
  final String hint, hintButton;
  final VoidCallback tapInkWell, tapButton;

  ActionAuth(this.hint,
      {required this.hintButton,
      required this.tapInkWell,
      required this.tapButton,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'action-auth',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: tapInkWell,
            borderRadius: BorderRadius.circular(5),
            splashColor: Colors.white.withOpacity(.5),
            highlightColor: Colors.white.withOpacity(.2),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                hint,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: tapButton,
            child: Text(hintButton),
          )
        ],
      ),
    );
  }
}
