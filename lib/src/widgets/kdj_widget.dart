import 'dart:math';

import 'package:flutter/material.dart';
import '../models/candle.dart';
import '../utils/data_util.dart';

class KDJWidget extends LeafRenderObjectWidget {
  final List<Candle> candles;
  final int index;
  final double barWidth;
  final double high;
  final Color kColor;
  final Color dColor;
  final Color jColor;

  KDJWidget({
    required this.candles,
    required this.index,
    required this.barWidth,
    required this.high,
    required this.kColor,
    required this.dColor,
    required this.jColor,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {

    return KDJRenderObject(
      candles,
      index,
      barWidth,
      high,
      kColor,
      dColor,
      jColor,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {

    KDJRenderObject kdjRenderObject = renderObject as KDJRenderObject;
    kdjRenderObject._candles = candles;
    kdjRenderObject._index = index;
    kdjRenderObject._barWidth = barWidth;
    kdjRenderObject._high = high;
    kdjRenderObject._kColor = kColor;
    kdjRenderObject._dColor = dColor;
    kdjRenderObject._jColor = jColor;
    kdjRenderObject.markNeedsPaint();
    super.updateRenderObject(context, renderObject);
  }
}

class KDJRenderObject extends RenderBox {
  late List<Candle> _candles;
  late int _index;
  late double _barWidth;
  late double _high;
  late Color _kColor;
  late Color _dColor;
  late Color _jColor;

  KDJRenderObject(
      List<Candle> candles,
      int index,
      double barWidth,
      double high,
      Color kColor,
      Color dColor,
      Color jColor,
      ) {
    _candles = candles;
    _index = index;
    _barWidth = barWidth;
    _high = high;
    _kColor = kColor;
    _dColor = dColor;
    _jColor = jColor;
  }

  /// 设置尺寸尽可能大
  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  /// 绘制KDJ指标线
  void paintLine(PaintingContext context, Offset offset, int index,
      double lastValue, double curValue, Color color, double range) {
    double x1 = size.width + offset.dx - (index + 0.5) * _barWidth;
    double y1 = offset.dy + (_high - lastValue) / range;
    double x2 = size.width + offset.dx - (index + 1.5) * _barWidth;
    double y2 = offset.dy + (_high - curValue) / range;

    context.canvas.drawLine(
      Offset(x1, y1),
      Offset(x2, y2),
      Paint()
        ..color = color
        ..strokeWidth = 1.0,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double range = _high / size.height;
    for (int i = 0; (i + 1) * _barWidth < size.width; i++) {
      if (i + _index >= _candles.length || i + _index < 1) continue;
      var lastCandle = _candles[i + _index - 1];
      var curCandle = _candles[i + _index];

      print("lastCandle.k===${lastCandle.k}");
      paintLine(context, offset, i, lastCandle.k??0, curCandle.k??0, _kColor, range);
      paintLine(context, offset, i, lastCandle.d??0, curCandle.d??0, _dColor, range);
      paintLine(context, offset, i, lastCandle.j??0, curCandle.j??0, _jColor, range);
    }
    context.canvas.save();
    context.canvas.restore();
  }

}
