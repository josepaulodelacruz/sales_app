import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
DateTime parseDate (String date) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime parsedDate = dateFormat.parse(date);
  return parsedDate;
}
