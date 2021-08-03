import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:make_up/component/card_job.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/user_model.dart';
import 'package:make_up/page/screen/detail_portfolio.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailUser extends StatefulWidget {
  final String type;
  final UserModel user;
  DetailUser(
    this.type, {
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _DetailUserState createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

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
      floatingActionButton: widget.user.phone == null
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.call),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Konfirmasi buka aplikasi"),
                    content:
                        Text("Apakah anda yakin ingin membuka WhatsApp  ?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Batal"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var url =
                              "https://wa.me/${widget.user.phone}?text=${Uri.parse("hello")}";

                          if (await canLaunch(url)) {
                            await launch(url);
                            return Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Coba lagi",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.orange,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Text("Lanjut"),
                      )
                    ],
                  ),
                );
              },
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _expansionTile(),
          TabBar(
            labelColor: GREY_COLOR,
            indicatorColor: GREY_COLOR,
            controller: tabController,
            tabs: [
              Tab(
                text: 'Jobs',
              ),
              Tab(
                text: 'Portfolio',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Scrollbar(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        ...widget.user.jobs!.map(
                          (e) => Column(
                            children: [
                              CardJob(
                                e,
                                imageHeight: Get.height / 10,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Scrollbar(
                  child: GridView.builder(
                    itemCount: widget.user.portfolio!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Get.to(
                            PortfolioDetail(widget.user.portfolio![index])),
                        child: widget.user.portfolio![index].image != null
                            ? Hero(
                                tag:
                                    'portfolio-${widget.user.portfolio![index].id}',
                                child: Image.asset(
                                  "assets/img/${widget.user.portfolio![index].image}",
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(child: Text("Empty image")),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _expansionTile() {
    return ExpansionTile(
      expandedAlignment: Alignment.topLeft,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 30),
      children: _expansionList(),
      leading: Hero(
        tag: 'image-${widget.user.id}-${widget.user.createdAt}',
        child: CircleAvatar(
          backgroundColor: PRIMARY_COLOR,
          backgroundImage: AssetImage('assets/img/${widget.user.image}'),
        ),
      ),
      title: Hero(
        tag: 'username-${widget.user.id}-${widget.user.createdAt}',
        child: Text(
          widget.user.name!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Hero(
        tag: 'address-${widget.user.id}-${widget.user.createdAt}',
        child: Row(
          children: [
            Icon(
              Icons.map,
              color: GREY_COLOR,
              size: 16,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              widget.user.address ?? "-",
            ),
          ],
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

  List<Widget> _expansionList() {
    return [
      widget.user.email == null
          ? Container()
          : Row(
              children: [
                Icon(
                  Icons.alternate_email,
                  color: GREY_COLOR,
                  size: 16,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(widget.user.email!)
              ],
            ),
      widget.user.phone == null
          ? Container()
          : Row(
              children: [
                Icon(
                  Icons.call,
                  color: GREY_COLOR,
                  size: 16,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(widget.user.phone!)
              ],
            ),
      widget.user.desc == null
          ? Container()
          : Container(
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
                widget.user.desc!,
                textAlign: TextAlign.center,
              ),
            ),
      Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Joined at\n${widget.user.createdAt!}",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      )
    ];
  }
}
