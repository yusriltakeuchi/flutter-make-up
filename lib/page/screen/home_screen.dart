import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/card_job.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/helper/mixin.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/page/search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with CustomClass {
  final ApiController apiController = Get.find();

  String filter = "Latest";
  Future<List<JobModel>>? listJob;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        listJob = apiController.listJobs();
      });
    });
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make Up You"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        elevation: 0.0,
      ),
      body: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        header: WaterDropMaterialHeader(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              search(),
              _head(),
              listJob == null
                  ? Container()
                  : StreamBuilder<List<JobModel>>(
                      stream: Stream.fromFuture(listJob!),
                      builder: (context, jobs) {
                        if (!jobs.hasData)
                          return CustomLinearProgressIndicator();
                        else {
                          return Column(
                            children: sortJobs(jobs.data!, filter)
                                .map(
                                  (e) => CardJob(
                                    e,
                                    imageHeight: Get.height / 2.5,
                                  ),
                                )
                                .toList(),
                          );
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget search() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      color: PRIMARY_COLOR,
      child: GestureDetector(
        onTap: () {
          showSearch(context: context, delegate: FindUser());
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Temukan make up ternama",
                style: TextStyle(
                  color: GREY_COLOR.withOpacity(.2),
                ),
              ),
              Icon(
                Icons.search,
                color: GREY_COLOR,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _head() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "List Jobs",
            style: TextStyle(
              fontSize: 32,
              color: GREY_COLOR,
              fontWeight: FontWeight.bold,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              type: MaterialType.transparency,
              child: PopupMenuButton(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: PRIMARY_COLOR.withOpacity(.1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "$filter",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.filter_list),
                    ],
                  ),
                ),
                onSelected: (val) {
                  setState(() {
                    filter = val!.toString();
                    if (filter == 'Latest') {
                      listJob = apiController.listJobs();
                    }
                  });
                  print(val);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Publish (latest)"),
                    value: 'Latest',
                  ),
                  PopupMenuItem(
                    child: Text("Publish (old)"),
                    value: 'Oldest',
                  ),
                  PopupMenuItem(
                    child: Text("Rating (high)"),
                    value: 'Top (rating)',
                  ),
                  PopupMenuItem(
                    child: Text("Rating (low)"),
                    value: 'Low (rating)',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder disabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(
        width: 0,
        color: Colors.white,
      ),
    );
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        listJob = apiController.listJobs();
      });
      _refreshController.loadComplete();
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        listJob = apiController.listJobs();
      });
      _refreshController.refreshCompleted();
    });
  }
}
