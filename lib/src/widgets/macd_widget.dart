import 'package:flutter/material.dart';
import '../models/candle.dart';

class MACDWidget extends LeafRenderObjectWidget {
  final List<Candle> candles;
  final int index;
  final double barWidth;
  final double high;
  final Color difColor;
  final Color deaColor;
  final Color positiveColor;
  final Color negativeColor;

  MACDWidget({
    required this.candles,
    required this.index,
    required this.barWidth,
    required this.high,
    required this.difColor,
    required this.deaColor,
    required this.positiveColor,
    required this.negativeColor,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MACDRenderObject(
      candles,
      index,
      barWidth,
      high,
      difColor,
      deaColor,
      positiveColor,
      negativeColor,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    MACDRenderObject macdRenderObject = renderObject as MACDRenderObject;
    macdRenderObject._candles = candles;
    macdRenderObject._index = index;
    macdRenderObject._barWidth = barWidth;
    macdRenderObject._high = high;
    macdRenderObject._difColor = difColor;
    macdRenderObject._deaColor = deaColor;
    macdRenderObject._positiveColor = positiveColor;
    macdRenderObject._negativeColor = negativeColor;
    macdRenderObject.markNeedsPaint();
    super.updateRenderObject(context, renderObject);
  }
}

class MACDRenderObject extends RenderBox {
  late List<Candle> _candles;
  late int _index;
  late double _barWidth;
  late double _high;
  late Color _difColor;
  late Color _deaColor;
  late Color _positiveColor;
  late Color _negativeColor;

  MACDRenderObject(
      List<Candle> candles,
      int index,
      double barWidth,
      double high,
      Color difColor,
      Color deaColor,
      Color positiveColor,
      Color negativeColor,
      ) {
    _candles = candles;
    _index = index;
    _barWidth = barWidth;
    _high = high;
    _difColor = difColor;
    _deaColor = deaColor;
    _positiveColor = positiveColor;
    _negativeColor = negativeColor;
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

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

  void paintBar(PaintingContext context, Offset offset, int index,
      double value, double range) {
    double x = size.width + offset.dx - (index + 1) * (_barWidth + 1);
    double y = offset.dy + (_high - value) / range;
    double yBase = offset.dy + (_high) / range;

    Paint paint = Paint()
      ..color = value >= 0 ? _positiveColor : _negativeColor
      ..style = value >= 0 ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.0;

    context.canvas.drawRect(
      Rect.fromPoints(Offset(x, y), Offset(x + _barWidth, yBase)),
      paint,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double range = _high / size.height;
    for (int i = 0; (i + 1) * _barWidth < size.width; i++) {
      if (i + _index >= _candles.length || i + _index < 1) continue;
      var lastCandle = _candles[i + _index - 1];
      var curCandle = _candles[i + _index];

      paintLine(context, offset, i, lastCandle.dif??0, curCandle.dif??0, _difColor, range);
      paintLine(context, offset, i, lastCandle.dea??0, curCandle.dea??0, _deaColor, range);
      paintBar(context, offset, i, curCandle.macd??0, range);
    }
    context.canvas.save();
    context.canvas.restore();
  }
}
