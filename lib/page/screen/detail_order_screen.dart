import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/component/custom_textformfield.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/transaction_model.dart';
import 'package:make_up/model/user_model.dart';
import 'package:make_up/page/home.dart';
import 'package:make_up/page/screen/detail_user.dart';

class DetailOrderScreen extends StatefulWidget {
  final Transaction transaction;
  final JobModel job;
  DetailOrderScreen(this.transaction, this.job, {Key? key}) : super(key: key);

  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  final ApiController apiController = Get.find();
  int? rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Detail Order",
          style: TextStyle(color: GREY_COLOR),
        ),
        iconTheme: IconThemeData(
          color: GREY_COLOR,
        ),
      ),
      backgroundColor: GREY_COLOR.withOpacity(.1),
      body: FutureBuilder<UserModel>(
        future: apiController.getUserDetail(widget.job.userId.toString()),
        builder: (context, user) {
          if (!user.hasData)
            return CustomLinearProgressIndicator();
          else {
            return Stack(
              children: [
                SizedBox.expand(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: GREY_COLOR.withOpacity(.4),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 80),
                                _cardUser(user.data!),
                                SizedBox(
                                  height: 100,
                                  child: Image.asset(
                                    'assets/img/${widget.job.image}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.job.name!,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: GREY_COLOR.withOpacity(.1),
                                        ),
                                        child: Text(
                                          widget.job.category!.name!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                _listTile(
                                  'Total',
                                  icon: Icons.person,
                                  trailing: widget.transaction.total.toString(),
                                ),
                                _listTile(
                                  'Date',
                                  icon: Icons.date_range,
                                  trailing: widget.transaction.date.toString(),
                                ),
                                _listTile(
                                  'Time',
                                  icon: Icons.access_time_sharp,
                                  trailing:
                                      "${widget.transaction.start} - ${widget.transaction.end}",
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Text(
                                      "Rp ${widget.job.price!}",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Offstage(
                            offstage: widget.transaction.status! == 'approved',
                            child: _confirmOrder(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: _header(),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _cardUser(UserModel user) {
    return ListTile(
      onTap: () => Get.to(
        DetailUser(
          'home',
          user: user,
        ),
      ),
      leading: Hero(
        tag: 'image-${user.id}-${user.createdAt}',
        child: CircleAvatar(
          backgroundColor: PRIMARY_COLOR,
          backgroundImage: AssetImage('assets/img/${user.image}'),
        ),
      ),
      title: Material(
        type: MaterialType.transparency,
        child: Hero(
          tag: 'username-${user.id}-${user.createdAt}',
          child: Text(
            user.name!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle: Hero(
        tag: 'address-${user.id}-${user.createdAt}',
        child: Text(
          user.address ?? "-",
        ),
      ),
      trailing: Hero(
        tag: 'indicator-${user.id}-${user.createdAt}',
        child: CircleAvatar(
          radius: 10,
          backgroundColor:
              user.status == "non-active" ? Colors.orange : Colors.green,
        ),
      ),
    );
  }

  ListTile _listTile(String title,
      {required IconData icon, required String trailing}) {
    return ListTile(
      title: Text(title),
      minLeadingWidth: 5,
      leading: Icon(
        icon,
        color: GREY_COLOR,
      ),
      trailing: Text(
        trailing,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _header() {
    return Hero(
      tag: 'status-${widget.transaction.id}',
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.transaction.status == 'approved'
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
                    widget.transaction.createdAt!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.transaction.status!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmOrder() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Apakah anda yakin ingin membatalkan pesanan"),
                  actions: [
                    TextButton(
                      child: Text("Kembali"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        Future.delayed(Duration(milliseconds: 100), () async {
                          await apiController
                              .deleteTransaction(widget.transaction.id!)
                              .then((value) {
                            Navigator.pop(context);
                            Get.back();
                          });
                        });
                      },
                      child: Text("Batalkan"),
                    )
                  ],
                ),
              );
            },
            child: Text(
              "Batalkan transaksi ?",
              style: TextStyle(
                color: SECONDARY_COLOR,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Konfirmasi transaksi"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        Future.delayed(Duration(milliseconds: 100), () async {
                          await apiController
                              .updateTransaction(widget.transaction.id!)
                              .then((value) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => _commentDialog(),
                            );
                          });
                        });
                      },
                      child: Text("Simpan"),
                    )
                  ],
                ),
              );
            },
            child: Text("Konfirmasi transaksi"),
          ),
        ],
      ),
      // child: ,
    );
  }

  AlertDialog _commentDialog() {
    return AlertDialog(
      title: Text("Berikan penilaian"),
      actions: [
        TextButton(
          child: Text("Lewati"),
          onPressed: () {
            Navigator.pop(context);
            Get.offAll(HomePage());
          },
        ),
        ElevatedButton(
          child: Text("Kirim"),
          onPressed: () async {
            await EasyLoading.show(
              status: 'loading...',
              maskType: EasyLoadingMaskType.black,
            );
            AuthController a = Get.find();
            if (apiController.commentController.value.text.isEmpty ||
                rating == 0) {
              apiController.showMessage(
                  'Kolom tidak boleh kosong', SECONDARY_COLOR);
            } else {
              Future.delayed(Duration(milliseconds: 100), () async {
                await apiController.storeComment(
                    a.authStorage.read('user')['id'], widget.job.id, rating!);
              }).then((value) {
                Navigator.pop(context);
                Get.offAll(HomePage());
              });
            }
          },
        )
      ],
      content: Container(
        height: 150,
        child: Column(
          children: [
            CustomTextFormField(
              'Berikan komentar anda',
              controller: apiController.commentController.value,
            ),
            SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: rating == null ? 0 : rating!.toDouble(),
              minRating: 0,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemSize: 30,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.orangeAccent,
              ),
              onRatingUpdate: (value) {
                setState(() => rating = value.toInt());
              },
            )
          ],
        ),
      ),
    );
  }
}
