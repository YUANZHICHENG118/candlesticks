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

  /// 绘制左上角的 KDJ 数值
  void paintText(PaintingContext context, Offset offset,Candle candle) {
    final Candle lastCandle = candle;

    final TextPainter textPainterDIF = TextPainter(
      text: TextSpan(
        text: 'DIF: ${lastCandle.dif?.toStringAsFixed(2) ?? 'N/A'}',
        style: TextStyle(color: _difColor, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter textPainterDEA = TextPainter(
      text: TextSpan(
        text: 'DEA: ${lastCandle.dea?.toStringAsFixed(2) ?? 'N/A'}',
        style: TextStyle(color: _deaColor, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter textPainterMACD = TextPainter(
      text: TextSpan(
        text: 'MACD: ${lastCandle.macd?.toStringAsFixed(2) ?? 'N/A'}',
        style: TextStyle(color: _positiveColor, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double textX = offset.dx + 10; // Adjust X position
    double textY = offset.dy + 10; // Adjust Y position

    textPainterDIF.paint(context.canvas, Offset(textX, textY));
    textPainterDEA.paint(context.canvas, Offset(textX+70, textY));
    textPainterMACD.paint(context.canvas, Offset(textX+140, textY));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double range = _high / size.height;
    Candle? lastVisibleCandle;

    for (int i = 0; (i + 1) * _barWidth < size.width; i++) {
      if (i + _index >= _candles.length || i + _index < 1) continue;
      var lastCandle = _candles[i + _index - 1];
      var curCandle = _candles[i + _index];

      paintLine(context, offset, i, lastCandle.dif??0, curCandle.dif??0, _difColor, range);
      paintLine(context, offset, i, lastCandle.dea??0, curCandle.dea??0, _deaColor, range);
      paintBar(context, offset, i, curCandle.macd??0, range);
      lastVisibleCandle = curCandle;
    }

    if (lastVisibleCandle != null) {
      paintText(context, offset, lastVisibleCandle); // 调用绘制文本方法
    }
    context.canvas.save();
    context.canvas.restore();
  }
}
