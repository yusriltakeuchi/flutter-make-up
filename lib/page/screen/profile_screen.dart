import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_iconbutton.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:make_up/helper/mixin.dart';
import 'package:make_up/model/transaction_model.dart';
import 'package:make_up/model/user_model.dart';
import 'package:make_up/page/screen/transaction_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileScreen extends StatefulWidget {
  final String id;
  ProfileScreen(this.id, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin, CustomClass {
  ScrollController scrollController = new ScrollController();
  TabController? tabController;

  AuthController authController = Get.find();
  ApiController apiController = Get.find();

  Future<UserModel>? userFuture;

  RefreshController _refreshControllerHistory =
      RefreshController(initialRefresh: false);
  RefreshController _refreshControllerUpcoming =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        userFuture = apiController.getUserDetail(widget.id);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Make Up You',
          style: TextStyle(
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CustomIconButton(
            tooltip: 'Keluar',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Konfirmasi keluar"),
                  content: Text("Apakah anda yakin ingin keluar ?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        return authController.logOut();
                      },
                      child: Text("Keluar"),
                    )
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.logout,
              color: GREY_COLOR,
            ),
          )
        ],
      ),
      body: userFuture == null
          ? Container()
          : StreamBuilder<UserModel>(
              stream: Stream.fromFuture(userFuture!),
              builder: (context, user) {
                if (!user.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomLinearProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        "Memuat data",
                        style: TextStyle(color: SECONDARY_COLOR),
                      ),
                    ],
                  );
                } else {
                  List<Transaction> listUpComing = [];
                  List<Transaction> listHistory = [];

                  for (int i = 0; i < user.data!.transaction!.length; i++) {
                    if (user.data!.transaction![i].status == "disapproved") {
                      listUpComing.add(user.data!.transaction![i]);
                    } else {
                      listHistory.add(user.data!.transaction![i]);
                    }
                  }
                  return NestedScrollView(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    headerSliverBuilder: (context, box) => [
                      _sliverAppBar(user),
                    ],
                    body: TabBarView(
                      physics: BouncingScrollPhysics(),
                      controller: tabController,
                      children: [
                        SmartRefresher(
                          controller: _refreshControllerUpcoming,
                          onLoading: _onLoading,
                          onRefresh: _onRefresh,
                          header: ClassicHeader(),
                          footer: ClassicFooter(),
                          child: TransactionScreen(listUpComing),
                        ),
                        SmartRefresher(
                          controller: _refreshControllerHistory,
                          onLoading: _onLoading,
                          onRefresh: _onRefresh,
                          header: ClassicHeader(),
                          footer: ClassicFooter(),
                          child: TransactionScreen(listHistory),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }

  _sliverAppBar(AsyncSnapshot<UserModel> user) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: Get.height / 2.5,
      floating: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: SECONDARY_COLOR,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/img/${user.data!.image!}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(user.data!.name!),
            ),
            Text(
              user.data!.email!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: user.data!.status != null
                          ? user.data!.status! == "non-active"
                              ? PRIMARY_COLOR
                              : Colors.green
                          : PRIMARY_COLOR,
                    ),
                    child: Text(
                      user.data!.status == null ? "-" : user.data!.status!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map),
                SizedBox(width: 5),
                Text(
                  getAddress(user.data!.address, user.data!.city),
                )
              ],
            ),
          ],
        ),
      ),
      bottom: TabBar(
        labelColor: SECONDARY_COLOR,
        indicatorColor: SECONDARY_COLOR,
        controller: tabController,
        tabs: [
          Tab(
            text: "In Progress",
          ),
          Tab(
            text: "History",
          ),
        ],
      ),
    );
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        userFuture = apiController.getUserDetail(widget.id);
      });
      _refreshControllerHistory.loadComplete();
      _refreshControllerUpcoming.loadComplete();
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        userFuture = apiController.getUserDetail(widget.id);
      });
      _refreshControllerHistory.refreshCompleted();
      _refreshControllerUpcoming.refreshCompleted();
    });
  }
}
