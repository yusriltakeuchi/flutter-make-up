import 'package:flutter/material.dart';
import 'package:make_up/component/const.dart';

class CustomIconButton extends StatelessWidget {
  final String tooltip;
  final VoidCallback? onTap;
  final Widget icon;
  CustomIconButton(
      {required this.tooltip, this.onTap, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Material(
        type: MaterialType.transparency,
        child: Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(100),
            splashColor: GREY_COLOR.withOpacity(.2),
            highlightColor: GREY_COLOR.withOpacity(.1),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
