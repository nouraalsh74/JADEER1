import 'package:flutter/material.dart';

import 'customDatePickerTheme.dart';

class MyDatePicker{
  Future<DateTime?> selectDate(BuildContext context , selectedDate ,) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ,
      firstDate: DateTime(1800),
      lastDate: DateTime(2101),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: CustomDatePickerTheme().datePickerTheme,
          child: child!,
        );
      },
    );
    if (picked != null ) {
      return picked;
    }
    return null;
  }
}