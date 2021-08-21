import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:make_up/helper/mixin.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/page/screen/home_screen.dart';
import 'package:make_up/page/screen/profile_screen.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with CustomClass {
  ApiController apiController = Get.find();
  AuthController authController = Get.find();

  PersistentTabController? tabController;

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      items: navbarItem(),
      confineInSafeArea: true,
      controller: tabController,
      margin: EdgeInsets.all(0.0),
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style9,
      handleAndroidBackButtonPress: true,
      screens: [
        HomeScreen(),
        ProfileScreen(
          authController.authStorage.read('user')['id'].toString(),
        )
      ],
    );
  }

  @override
  void initState() {
    tabController = new PersistentTabController(initialIndex: 0);

    if (apiController.listCategory.isEmpty) {
      Future.delayed(Duration(milliseconds: 1500), () async {
        await apiController.getListCategory().then((value) {
          for (int i = 0; i < value.length; i++) {
            apiController.listCategory.add(value[i]['name']);
          }
        });
      }).whenComplete(() => setState(() {}));
    }

    super.initState();
  }
}
