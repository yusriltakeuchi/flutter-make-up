import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/model/job_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

mixin CustomClass {
  String getAddress(String? address, String? city) {
    if (address == null && city == null) {
      return '-';
    } else if (address == null && city != null) {
      return city;
    } else if (address != null && city == null) {
      return address;
    } else {
      return "$address, $city";
    }
  }

  List<JobModel> sortJobs(List<JobModel> listData, String filter) {
    switch (filter) {
      case 'Oldest':
        return listData.reversed.toList();
      case 'Top (rating)':
        listData.sort((a, b) => b.rating!.compareTo(a.rating!));
        return listData;
      case 'Low (rating)':
        listData.sort((a, b) => a.rating!.compareTo(b.rating!));
        return listData;
      default:
        return listData;
    }
  }

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
