import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/helper/mixin.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/user_model.dart';
import 'package:make_up/page/booking.dart';
import 'package:make_up/page/screen/detail_user.dart';

class DetailPage extends StatefulWidget {
  final JobModel job;
  final UserModel user;
  DetailPage({
    required this.job,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with CustomClass {
  double? rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomScrollView(
              slivers: [
                customSliverAppbar(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _cardUser(),
                      Divider(
                        thickness: 1,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Hero(
                              tag: 'title-${widget.job.id}',
                              child: Text(
                                widget.job.name!,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Last update ${widget.job.createdAt!}",
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: GREY_COLOR.withOpacity(.1),
                        ),
                        child: Text(
                          widget.job.category!.name!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Text(widget.job.desc!),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Lokasi :"),
                            SizedBox(width: 10),
                            Text(
                              getAddress(widget.user.address, widget.user.city),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tersedia pada :"),
                            SizedBox(width: 10),
                            Text("${widget.job.start!} - ${widget.job.end!}")
                          ],
                        ),
                      ),
                      if (widget.job.comment!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Divider(
                                thickness: 1,
                              ),
                              Text(
                                "Comment",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ...widget.job.comment!.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            PRIMARY_COLOR.withOpacity(.18),
                                        backgroundImage: AssetImage(
                                            'assets/img/${e.imageAuthor}'),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  e.author!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    e.createdAt.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              e.content == null
                                                  ? ""
                                                  : e.content!,
                                            )
                                          ],
                                        ),
                                      ),
                                      Badge(
                                        badgeContent: Text(
                                          e.star.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.star,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _booking(),
        ],
      ),
    );
  }

  Widget _cardUser() {
    return ListTile(
      onTap: () => Get.to(
        DetailUser(
          'home',
          user: widget.user,
        ),
        transition: Transition.downToUp,
        duration: Duration(milliseconds: 800),
      ),
      leading: Hero(
        tag: 'image-${widget.user.id}-${widget.user.createdAt}',
        child: CircleAvatar(
          backgroundColor: PRIMARY_COLOR,
          backgroundImage: AssetImage('assets/img/${widget.user.image}'),
        ),
      ),
      title: Material(
        type: MaterialType.transparency,
        child: Hero(
          tag: 'username-${widget.user.id}-${widget.user.createdAt}',
          child: Text(
            widget.user.name!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle: Hero(
        tag: 'address-${widget.user.id}-${widget.user.createdAt}',
        child: Text(
          widget.user.address ?? "-",
        ),
      ),
      trailing: Hero(
        tag: 'indicator-${widget.user.id}-${widget.user.createdAt}',
        child: CircleAvatar(
          radius: 10,
          backgroundColor:
              widget.user.status == "non-active" ? Colors.orange : Colors.green,
        ),
      ),
    );
  }

  Positioned _booking() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Hero(
        tag: 'btn-booking',
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    "Rp ${widget.job.price}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: PRIMARY_COLOR,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              btnBooking()
            ],
          ),
        ),
      ),
    );
  }

  Widget btnBooking() {
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(
          msg: "MUA sedang Offline",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          fontSize: 16.0,
        );
      },
      child: ElevatedButton(
        onPressed: widget.job.status == 'non-active'
            ? null
            : () => Get.to(
                  BookingPage(
                    job: widget.job,
                    user: widget.user,
                  ),
                  transition: Transition.downToUp,
                  duration: Duration(milliseconds: 800),
                ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled))
                return SECONDARY_COLOR.withOpacity(.5);
              return PRIMARY_COLOR;
            },
          ),
        ),
        child: Text("Booking"),
      ),
    );
  }

  customSliverAppbar() {
    return SliverAppBar(
      expandedHeight: Get.height / 2.5,
      elevation: 0.0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Hero(
                tag: 'thumbnail-${widget.job.id}',
                child: Image.asset(
                  "assets/img/${widget.job.image}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0),
                      ],
                      stops: [0, 0.5],
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
