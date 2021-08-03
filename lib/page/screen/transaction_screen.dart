import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/card_job.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/transaction_model.dart';
import 'package:make_up/page/screen/detail_order_screen.dart';

class TransactionScreen extends StatelessWidget {
  final List<Transaction> listData;
  TransactionScreen(this.listData, {Key? key}) : super(key: key);

  final ApiController apiController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (listData.isEmpty)
      return emptyData();
    else
      return body();
  }

  body() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 20),
          ...listData.map(
            (e) => FutureBuilder<JobModel>(
              future: apiController.getJob(e.jobId.toString()),
              builder: (context, job) {
                if (!job.hasData)
                  return Container();
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'status-${e.id}',
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: e.status == 'approved'
                                ? Colors.green[100]
                                : Colors.orange[200],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time_rounded),
                                    SizedBox(width: 5),
                                    Text(
                                      e.createdAt!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                e.status!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CardJob(
                        job.data!,
                        onTap: () => Get.to(
                          DetailOrderScreen(e, job.data!),
                        ),
                        imageHeight: Get.height / 10,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }

  emptyData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(
                Icons.access_time_rounded,
                size: 40,
              ),
              SizedBox(height: 20),
              Text(
                "Transaksi Masih kosong",
                style: TextStyle(
                  fontSize: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
