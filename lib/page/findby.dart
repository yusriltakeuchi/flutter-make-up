import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/card_job.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/helper/mixin.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FindByPage extends StatefulWidget {
  final String type;
  final String title;
  const FindByPage(this.type, this.title, {Key? key}) : super(key: key);

  @override
  _FindByPageState createState() => _FindByPageState();
}

class _FindByPageState extends State<FindByPage> with CustomClass {
  final ApiController apiController = Get.find();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppbar(),
      body: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: Scrollbar(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification? overscroll) {
              overscroll!.disallowGlow();
              return true;
            },
            child: listJob == null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomLinearProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: StreamBuilder<List<JobModel>>(
                      stream: Stream.fromFuture(listJob!),
                      builder: (context, jobs) {
                        if (!jobs.hasData)
                          return Container();
                        else {
                          List<JobModel> results = jobs.data!
                              .where((e) => widget.title == 'City'
                                  ? e.city!.contains(widget.type)
                                  : e.category!.name!.contains(widget.type))
                              .toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      widget.title == 'City'
                                          ? "🏙 ${widget.type}"
                                          : "${widget.type}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Offstage(
                                      offstage:
                                          sortJobs(results, filter).isNotEmpty,
                                      child: Text("Data kosong"),
                                    ),
                                  ],
                                ),
                              ),
                              // if(widget.type == 'City') ...jobs.data!.map(
                              //       (e) => StreamBuilder<UserModel>(
                              //         stream: Stream.fromFuture(apiController.getUserDetail(e.userId.toString())),
                              //         builder: (context, user) {
                              //           if(!user.hasData) return Container();
                              //           else {
                              //             return CardJob(
                              //               e,
                              //               imageHeight: Get.height / 2.2,
                              //             );
                              //           }
                              //         },
                              //       ),
                              // ),
                              ...sortJobs(results, filter).map(
                                (e) => CardJob(
                                  e,
                                  imageHeight: Get.height / 2.2,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  _customAppbar() {
    return AppBar(
      title: Hero(
        tag: 'find-by-${widget.title}',
        child: Text("Find by ${widget.title}"),
      ),
      centerTitle: false,
      elevation: 0.0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Material(
              type: MaterialType.transparency,
              child: PopupMenuButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white.withOpacity(.2),
                  child: Row(
                    children: [
                      Text(
                        "$filter",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
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
        ),
        SizedBox(
          width: 10,
        ),
      ],
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
