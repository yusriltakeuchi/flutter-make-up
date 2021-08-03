import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:make_up/component/const.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> list;
  final Function(String?)? onChanged;
  CustomDropdownField(this.list, this.label, {this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownSearch<String>(
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 2,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(
            color: GREY_COLOR,
            fontWeight: FontWeight.w400,
          ),
          focusedBorder: defaultBorder(
            SECONDARY_COLOR,
          ),
          errorBorder: defaultBorder(
            GREY_COLOR,
          ),
          enabledBorder: defaultBorder(
            SECONDARY_COLOR.withOpacity(.3),
          ),
        ),
        mode: Mode.MENU,
        items: list,
        label: label,
        onChanged: onChanged!,
        // selectedItem: city[0],
      ),
    );
  }

  OutlineInputBorder defaultBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
