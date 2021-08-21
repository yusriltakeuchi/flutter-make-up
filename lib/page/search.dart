import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_iconbutton.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/model/user_model.dart';
import 'package:make_up/page/findby.dart';
import 'package:make_up/page/screen/detail_user.dart';

class FindUser extends SearchDelegate<UserModel> {
  ApiController apiController = Get.find();

  List<String> listCity = [
    'Jakarta Pusat',
    'Jakarta Utara',
    'Jakarta Barat',
    'Jakarta Timur',
    'Jakarta Selatan',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      CustomIconButton(
        tooltip: 'clear',
        icon: Icon(Icons.clear),
        onTap: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return CustomIconButton(
      tooltip: 'back',
      icon: Icon(Icons.arrow_back),
      onTap: () {
        close(context, UserModel());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scrollbar(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification? overscroll) {
          overscroll!.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Hero(
                  tag: 'find-by-City',
                  child: Text(
                    "🏙 Find by City",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ...ListTile.divideTiles(
                context: context,
                tiles: listCity.map(
                  (e) => ListTile(
                    title: Text(e),
                    onTap: () => Get.to(FindByPage(e, 'City')),
                  ),
                ),
                color: GREY_COLOR.withOpacity(.8),
              ),
              Container(
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: GREY_COLOR.withOpacity(.2),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Hero(
                  tag: 'find-by-Category',
                  child: Text(
                    "Find by Category : ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ...ListTile.divideTiles(
                context: context,
                tiles: apiController.listCategory.map(
                  (e) => ListTile(
                    title: Text(e),
                    onTap: () => Get.to(FindByPage(e, 'Category')),
                  ),
                ),
                color: GREY_COLOR.withOpacity(.8),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: Stream.fromFuture(apiController.getAllUsers()),
      builder: (context, user) {
        if (!user.hasData)
          return Center(
            child: Text("Data kosong"),
          );
        else {
          List<UserModel> results = user.data!
              .where((e) => e.name!.toLowerCase().contains(query))
              .toList();

          return ListView(
            children: results
                .map(
                  (e) => ListTile(
                    onTap: () => Get.to(
                      DetailUser(
                        'home',
                        user: e,
                      ),
                      transition: Transition.downToUp,
                      duration: Duration(milliseconds: 800),
                    ),
                    title: Text(e.name!),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/img/${e.image!}"),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: e.status != null
                            ? e.status! == "non-active"
                                ? PRIMARY_COLOR
                                : Colors.green
                            : PRIMARY_COLOR,
                      ),
                      child: Text(
                        e.status!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }
}
