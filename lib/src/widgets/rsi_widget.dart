import 'package:flutter/material.dart';
import '../models/candle.dart';

class RSIWidget extends LeafRenderObjectWidget {
  final List<Candle> candles;
  final int index;
  final double barWidth;
  final double high;
  final Color rsi1Color;
  final Color rsi2Color;
  final Color rsi3Color;
  final double lineWidth;

  RSIWidget({
    required this.candles,
    required this.index,
    required this.barWidth,
    required this.high,
    required this.rsi1Color,
    required this.rsi2Color,
    required this.rsi3Color,
    required this.lineWidth,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RSIRenderObject(
      candles,
      index,
      barWidth,
      high,
      rsi1Color,
      rsi2Color,
      rsi3Color,
      lineWidth,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    RSIRenderObject rsiRenderObject = renderObject as RSIRenderObject;
    rsiRenderObject._candles = candles;
    rsiRenderObject._index = index;
    rsiRenderObject._barWidth = barWidth;
    rsiRenderObject._high = high;
    rsiRenderObject._rsi1Color = rsi1Color;
    rsiRenderObject._rsi2Color = rsi2Color;
    rsiRenderObject._rsi3Color = rsi3Color;
    rsiRenderObject._lineWidth = lineWidth;
    rsiRenderObject.markNeedsPaint();
    super.updateRenderObject(context, renderObject);
  }
}

class RSIRenderObject extends RenderBox {
  late List<Candle> _candles;
  late int _index;
  late double _barWidth;
  late double _high;
  late Color _rsi1Color;
  late Color _rsi2Color;
  late Color _rsi3Color;
  late double _lineWidth;

  RSIRenderObject(
      List<Candle> candles,
      int index,
      double barWidth,
      double high,
      Color rsi1Color,
      Color rsi2Color,
      Color rsi3Color,
      double lineWidth,
      ) {
    _candles = candles;
    _index = index;
    _barWidth = barWidth;
    _high = high;
    _rsi1Color = rsi1Color;
    _rsi2Color = rsi2Color;
    _rsi3Color = rsi3Color;
    _lineWidth = lineWidth;
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  void paintLine(PaintingContext context, Offset offset, int index, double? lastValue, double? curValue, Color color, double range) {
    if (lastValue == null || curValue == null) return;

    double x1 = size.width + offset.dx - (index + 0.5) * (_barWidth + 1);
    double y1 = offset.dy + (_high - lastValue) / range;
    double x2 = size.width + offset.dx - (index + 1.5) * (_barWidth + 1);
    double y2 = offset.dy + (_high - curValue) / range;

    context.canvas.drawLine(
      Offset(x1, y1),
      Offset(x2, y2),
      Paint()
        ..color = color
        ..strokeWidth = _lineWidth,
    );
  }

  void paintText(PaintingContext context, Offset offset) {
    final TextPainter textPainter1 = TextPainter(
      text: TextSpan(
        text: 'RSI1: ${_candles.last.rsi1?.toStringAsFixed(2) ?? 'N/A'}',
        style: TextStyle(color: _rsi1Color, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter textPainter2 = TextPainter(
      text: TextSpan(
        text: 'RSI2: ${_candles.last.rsi2?.toStringAsFixed(2) ?? 'N/A'}',
        style: TextStyle(color: _rsi2Color, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter textPainter3 = TextPainter(
      text: TextSpan(
        text: 'RSI3: ${_candles.last.rsi3?.toStringAsFixed(2) ?? 'N/A'}',
        style: TextStyle(color: _rsi3Color, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double textX = offset.dx + 10; // Adjust X position
    double textY = offset.dy + 10; // Adjust Y position

    textPainter1.paint(context.canvas, Offset(textX, textY));
    textPainter2.paint(context.canvas, Offset(textX+70, textY));
    textPainter3.paint(context.canvas, Offset(textX+140, textY));
  }


  @override
  void paint(PaintingContext context, Offset offset) {
    double range = _high / size.height;
    for (int i = 0; (i + 1) * (_barWidth + 1) < size.width; i++) {
      if (i + _index >= _candles.length || i + _index < 1) continue;
      var lastCandle = _candles[i + _index - 1];
      var curCandle = _candles[i + _index];

      paintLine(context, offset, i, lastCandle.rsi1, curCandle.rsi1, _rsi1Color, range);
      paintLine(context, offset, i, lastCandle.rsi2, curCandle.rsi2, _rsi2Color, range);
      paintLine(context, offset, i, lastCandle.rsi3, curCandle.rsi3, _rsi3Color, range);
    }

    paintText(context, offset);

    context.canvas.save();
    context.canvas.restore();
  }
}
