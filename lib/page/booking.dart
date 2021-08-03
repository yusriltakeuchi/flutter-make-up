import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_iconbutton.dart';
import 'package:make_up/component/custom_textformfield.dart';
import 'package:make_up/helper/api_controller.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/user_model.dart';

class BookingPage extends StatefulWidget {
  final JobModel job;
  final UserModel user;

  BookingPage({
    required this.job,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ApiController apiController = Get.find();
  TimeOfDay selectedTime = TimeOfDay.now();
  var formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    apiController.peopleController.value = new TextEditingController(text: '0');
    super.initState();
  }

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
      body: IgnorePointer(
        ignoring: loading,
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _cardUser(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 100,
                              child: Hero(
                                tag: 'thumbnail-${widget.job.id}',
                                child: Image.asset(
                                  'assets/img/${widget.job.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
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
                                  Text("Please field this form"),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            _totalPeople(),
                            Divider(
                              thickness: 1,
                            ),
                            _contactPerson(),
                            Divider(
                              thickness: 1,
                            ),
                            _dateTime(),
                            SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _booking()
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardUser() {
    return ListTile(
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

  Widget _totalPeople() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: Text(
              "Total People",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GetBuilder<ApiController>(
              init: apiController,
              builder: (context) => Row(
                children: [
                  Opacity(
                    opacity: apiController.peopleController.value.text == '0'
                        ? .2
                        : 1.0,
                    child: CustomIconButton(
                      icon: Icon(Icons.exposure_minus_1),
                      tooltip: 'min',
                      onTap: apiController.peopleController.value.text == '0'
                          ? null
                          : () {
                              var num = int.parse(
                                  apiController.peopleController.value.text);
                              if (num != 0) {
                                num--;
                                apiController.peopleController.value.text =
                                    num.toString();
                                setState(() {});
                              }
                            },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTextFormField(
                        '0',
                        controller: apiController.peopleController.value,
                        type: TextInputType.number,
                        errorColor: SECONDARY_COLOR,
                      ),
                    ),
                  ),
                  CustomIconButton(
                    tooltip: 'add',
                    icon: Icon(Icons.plus_one),
                    onTap: () {
                      var num =
                          int.parse(apiController.peopleController.value.text);
                      num++;
                      apiController.peopleController.value.text =
                          num.toString();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _contactPerson() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Contact person",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text("Address : "),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 6,
                child: CustomTextFormField(
                  'Address',
                  controller: apiController.addressController.value,
                  errorColor: SECONDARY_COLOR,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text("Phone : "),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 6,
                child: CustomTextFormField(
                  '08774444',
                  controller: apiController.phoneController.value,
                  errorColor: SECONDARY_COLOR,
                  type: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateTime() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Schedule",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text("Date : "),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 6,
                child: _picker(apiController.dateController.value, 'start'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Text("Time :"),
          ),
          Row(
            children: [
              Expanded(
                child: btnTimePicker(
                  apiController.startController.value,
                  apiController.startController.value.text.isEmpty
                      ? "Start"
                      : apiController.startController.value.text,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: btnTimePicker(
                  apiController.endController.value,
                  apiController.endController.value.text.isEmpty
                      ? "End"
                      : apiController.endController.value.text,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  btnTimePicker(TextEditingController controller, String title) {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        String _hour, _minute, _time;

        if (picked != null)
          setState(() {
            selectedTime = picked;
            _hour = selectedTime.hour.toString();
            _minute = selectedTime.minute.toString();
            _time = _hour + ':' + _minute;
            controller.text = _time;
            // apiController.startController.value.text = formatDate(
            //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            //     [hh, ':', nn, " ", am]).toString();
          });
      },
      child: Text(
        title,
      ),
    );
  }

  Widget _picker(TextEditingController controller, String hint) {
    return DateTimePicker(
      controller: controller,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      validator: (val) {
        if (val!.isEmpty) {
          return '* required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: SECONDARY_COLOR,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.blue),
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
    return ElevatedButton(
      onPressed: () async {
        await EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        AuthController a = Get.find();
        if (formKey.currentState!.validate()) {
          var _start = apiController.startController.value.text;
          var _end = apiController.endController.value.text;

          if (_start.isEmpty && _end.isEmpty) {
            apiController.showMessage(
              "Form can't null",
              SECONDARY_COLOR,
            );
          } else {
            int userId = a.authStorage.read('user')['id'];

            Future.delayed(Duration(milliseconds: 5500), () async {
              await apiController.storeOrder(userId, widget.job.id);
            }).then(
              (value) => apiController.showMessage(
                'Connection timed out',
                SECONDARY_COLOR,
              ),
            );
          }
        } else {
          apiController.showMessage(
              'Data tidak memenuhi syarat', SECONDARY_COLOR);
        }
      },
      child: Text("Confirm"),
    );
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
}
