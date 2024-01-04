import 'package:flutter/material.dart';

class URLProvider extends ChangeNotifier {
  String? _url = '';
  String get url => _url!;

  void updateUrl(String newUrl) {
    _url = newUrl;
    notifyListeners();
  }
}
