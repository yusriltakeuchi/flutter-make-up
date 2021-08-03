import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/model/portfolio_model.dart';

class PortfolioDetail extends StatelessWidget {
  final Portfolio data;
  PortfolioDetail(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Detail User",
          style: TextStyle(color: GREY_COLOR),
        ),
        iconTheme: IconThemeData(
          color: GREY_COLOR,
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: Get.height / 2.2,
                child: Hero(
                  tag: 'portfolio-${data.id}',
                  child: Image.asset(
                    "assets/img/${data.image}",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Column(
                  children: [
                    Text(
                      data.description!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Published at"),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              data.createdAt!,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
