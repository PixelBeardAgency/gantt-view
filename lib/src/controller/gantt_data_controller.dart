import 'package:flutter/material.dart';

class GanttChartController<T> extends ChangeNotifier {
  Offset _panOffset = Offset.zero;
  Offset get panOffset => _panOffset;

  Offset _tooltipOffset = Offset.zero;
  Offset get tooltipOffset => _tooltipOffset;
  
  void setTooltipOffset(Offset offset) {
    _tooltipOffset = offset;
    notifyListeners();
  }

  void setPanOffset(Offset offset) {
    final diff = (panOffset - offset);
    _panOffset = offset;
    _tooltipOffset -= diff;
    notifyListeners();
  }

  void setPanY(double offset) {
    _panOffset = Offset(panOffset.dx, -offset);
    notifyListeners();
  }

  void setPanX(double offset) {
    _panOffset = Offset(-offset, panOffset.dy);
    notifyListeners();
  }
}
