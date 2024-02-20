import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// From https://stackoverflow.com/questions/49307677/how-can-i-get-the-height-of-a-widget/74701386#74701386
/// Small utility to measure a widget before actually putting it on screen.
///
/// This can be helpful e.g. for positioning context menus based on the size they will take up.
///
/// NOTE: Use sparingly, since this takes a complete layout and sizing pass for the subtree you
/// want to measure.
///
/// Compare https://api.flutter.dev/flutter/widgets/BuildOwner-class.html
class MeasureUtil {
  static Size measureWidget(Widget widget,
      [BoxConstraints constraints = const BoxConstraints()]) {
    final PipelineOwner pipelineOwner = PipelineOwner();
    final _MeasurementView rootView =
        pipelineOwner.rootNode = _MeasurementView(constraints);
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    final RenderObjectToWidgetElement<RenderBox> element =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: rootView,
      debugShortDescription: '[root]',
      child: Directionality(textDirection: TextDirection.ltr, child: widget),
    ).attachToRenderTree(buildOwner);
    try {
      rootView.scheduleInitialLayout();
      pipelineOwner.flushLayout();
      return rootView.size;
    } finally {
      // Clean up.
      element
          .update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
      buildOwner.finalizeTree();
    }
  }
}

class _MeasurementView extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  final BoxConstraints boxConstraints;
  _MeasurementView(this.boxConstraints);

  @override
  void performLayout() {
    assert(child != null);
    child!.layout(boxConstraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void debugAssertDoesMeetConstraints() => true;
}
