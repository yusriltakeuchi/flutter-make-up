import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:make_up/component/const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

mixin CustomClass {
  void setStatusBar() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  List<PersistentBottomNavBarItem> navbarItem() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: SECONDARY_COLOR,
        inactiveColorPrimary: PRIMARY_COLOR.withOpacity(.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: SECONDARY_COLOR,
        inactiveColorPrimary: PRIMARY_COLOR.withOpacity(.5),
      ),
    ];
  }
}
