import 'package:flutter/material.dart';

class SyncedScrollController extends ChangeNotifier {
  double _offset = 0;
  double get offset => _offset;

  bool isScrolling = false;

  final List<ScrollController> _controllers = [];

  void add(ScrollController controller) {
    _controllers.add(controller);
  }

  void remove(ScrollController controller) {
    _controllers.remove(controller);
  }

  void _updateScrollPosition(double offset) {
    isScrolling = true;
    _offset = offset;
    for (final controller in _controllers) {
      controller.jumpTo(offset);
    }
    isScrolling = false;
    notifyListeners();
  }

  bool onScroll(ScrollNotification scrollInfo) {
    if (!isScrolling) {
      _updateScrollPosition(scrollInfo.metrics.pixels);
    }
    return false;
  }
}
