import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/user_model.dart';
import 'package:make_up/page/detail.dart';

class CardJob extends StatelessWidget {
  final double imageHeight;
  final JobModel job;
  final VoidCallback? onTap;
  CardJob(
    this.job, {
    this.onTap,
    required this.imageHeight,
    Key? key,
  }) : super(key: key);

  final ApiController apiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: apiController.getUserDetail(job.userId.toString()),
      builder: (context, user) {
        if (!user.hasData)
          return Container();
        else {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              // onTap: () {},
              onTap: onTap == null
                  ? () => Get.to(
                        DetailPage(
                          job: job,
                          user: user.data!,
                        ),
                        transition: Transition.downToUp,
                      )
                  : onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: imageHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/img/${job.image}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: PRIMARY_COLOR,
                              backgroundImage:
                                  AssetImage('assets/img/${user.data!.image}'),
                            ),
                            title: Text(
                              user.data!.name!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              user.data!.address ?? "undefined",
                            ),
                            trailing: Badge(
                              badgeContent: Text(
                                job.comment!.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Icon(
                                Icons.comment,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: GREY_COLOR.withOpacity(.1),
                            ),
                            child: Text(
                              job.category!.name!,
                            ),
                          ),
                          Text(
                            "Rp ${job.price}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
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
      },
    );
  }
}
