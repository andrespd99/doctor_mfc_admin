import 'dart:async';

import 'package:flutter/material.dart';

class PageChangeService {
  StreamController<Widget> _pageController =
      new StreamController<Widget>.broadcast();

  Stream<Widget> get currentPage => _pageController.stream;
  Function(Widget body) get changePage => _pageController.sink.add;

  void dispose() {
    _pageController.close();
  }
}
