import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/card_job.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_iconbutton.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/page/search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiController apiController = Get.find();

  bool showFilter = false;
  String? filter;
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
              StreamBuilder<List<JobModel>>(
                stream: Stream.fromFuture(apiController.listJobs()),
                builder: (context, jobs) {
                  if (!jobs.hasData)
                    return CustomLinearProgressIndicator();
                  else {
                    List<JobModel> listFilter = [];

                    for (int i = 0; i < jobs.data!.length; i++) {
                      if (jobs.data![i].category!.name == filter) {
                        listFilter.add(jobs.data![i]);
                      }
                    }

                    return Column(
                      children: showFilter
                          ? listFilter.isEmpty
                              ? [Center(child: Text("Data kosong"))]
                              : listFilter
                                  .map((e) => CardJob(
                                        e,
                                        imageHeight: Get.height / 2.5,
                                      ))
                                  .toList()
                          : jobs.data!
                              .map((e) => CardJob(
                                    e,
                                    imageHeight: Get.height / 2.5,
                                  ))
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
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
              PopupMenuButton(
                icon: Icon(Icons.filter_list),
                onSelected: (val) {
                  setState(() {
                    showFilter = true;
                    filter = val.toString();
                  });
                },
                itemBuilder: (context) => apiController.listCategory
                    .map((element) => PopupMenuItem(
                          value: element,
                          child: Text(element),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !showFilter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: PRIMARY_COLOR,
                    ),
                    child: Text(
                      filter ?? "",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CustomIconButton(
                  tooltip: "Hapus",
                  onTap: () {
                    setState(() {
                      showFilter = false;
                      filter!;
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: SECONDARY_COLOR,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
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
