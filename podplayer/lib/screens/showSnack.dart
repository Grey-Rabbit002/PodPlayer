// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showSnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
