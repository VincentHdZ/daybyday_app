import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/daybyday_theme_app.dart';

class DatePickerFormField extends StatefulWidget {
  final DateTime birthday;
  final birthdayController;

  DatePickerFormField({this.birthday, this.birthdayController});

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy');
  DateTime _birthdayUpdated = DateTime.now();

  @override
  void initState() {
    _birthdayUpdated = widget.birthday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TextButton(
          child: Icon(
            Icons.date_range,
            color: DayByDayAppTheme.accentColor,
          ),
          onPressed: () async {
            final DateTime value = await showDatePicker(
              context: context,
              locale: const Locale("fr", "FR"),
              initialDate: DateTime.now(),
              firstDate: DateTime(1885),
              lastDate: DateTime(2030),
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: DayByDayAppTheme.accentColor,
                      onPrimary: Colors.white,
                    ),
                    accentColor: DayByDayAppTheme.accentColor,
                    buttonTheme: ButtonThemeData(
                      buttonColor: DayByDayAppTheme.accentColor,
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.transparent,
                    ),
                  ),
                  child: child,
                );
              },
            );
            if (value != null) {
              setState(() {
                _birthdayUpdated = value;
                widget.birthdayController.text =
                    dateTimeFormatter.format(_birthdayUpdated);
              });
            }
          },
        ),
        Container(
          width: ScreenUtil().setWidth(290),
          child: TextFormField(
            keyboardType: TextInputType.datetime,
            cursorColor: Color.fromRGBO(0, 176, 255, 0.9),
            controller: widget.birthdayController,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
                labelText: _birthdayUpdated != null
                    ? dateTimeFormatter.format(_birthdayUpdated)
                    : "Ajouter une date",
                labelStyle: TextStyle(
                  color: Colors.grey[700],
                ),
                border: UnderlineInputBorder(borderSide: BorderSide.none)),
            onSaved: (value) {
              if (value.isNotEmpty) {
                widget.birthdayController.text = value;
              }
            },
          ),
        ),
      ],
    );
  }
}
