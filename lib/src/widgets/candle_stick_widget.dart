import 'package:candlesticks/src/models/candle.dart';
import 'package:flutter/material.dart';
import '../models/candle.dart';

class CandleStickWidget extends LeafRenderObjectWidget {
  final List<Candle> candles;
  final int index;
  final double candleWidth;
  final double high;
  final double low;
  final Color bullColor;
  final Color bearColor;

  final bool isLine;

  CandleStickWidget({
    required this.candles,
    required this.index,
    required this.candleWidth,
    required this.low,
    required this.high,
    required this.bearColor,
    required this.bullColor,
    required this.isLine
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CandleStickRenderObject(
      candles,
      index,
      candleWidth,
      low,
      high,
      bullColor,
      bearColor,
      isLine
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    CandleStickRenderObject candlestickRenderObject =
        renderObject as CandleStickRenderObject;

    if (index <= 0 && candlestickRenderObject._close != candles[0].close) {
      candlestickRenderObject._candles = candles;
      candlestickRenderObject._index = index;
      candlestickRenderObject._candleWidth = candleWidth;
      candlestickRenderObject._high = high;
      candlestickRenderObject._low = low;
      candlestickRenderObject._bullColor = bullColor;
      candlestickRenderObject._bearColor = bearColor;
      candlestickRenderObject.markNeedsPaint();
    } else if (candlestickRenderObject._index != index ||
        candlestickRenderObject._candleWidth != candleWidth ||
        candlestickRenderObject._high != high ||
        candlestickRenderObject._low != low) {
      candlestickRenderObject._candles = candles;
      candlestickRenderObject._index = index;
      candlestickRenderObject._candleWidth = candleWidth;
      candlestickRenderObject._high = high;
      candlestickRenderObject._low = low;
      candlestickRenderObject._bullColor = bullColor;
      candlestickRenderObject._bearColor = bearColor;
      candlestickRenderObject.markNeedsPaint();
    }
    super.updateRenderObject(context, renderObject);
  }
}

class CandleStickRenderObject extends RenderBox {
  late List<Candle> _candles;
  late int _index;
  late double _candleWidth;
  late double _low;
  late double _high;
  late double _close;
  late Color _bullColor;
  late Color _bearColor;
  late bool _isLine;
  CandleStickRenderObject(
    List<Candle> candles,
    int index,
    double candleWidth,
    double low,
    double high,
    Color bullColor,
    Color bearColor,
      bool isLine,
  ) {
    _candles = candles;
    _index = index;
    _candleWidth = candleWidth;
    _low = low;
    _high = high;
    _bearColor = bearColor;
    _bullColor = bullColor;
    _isLine =isLine;
  }

  /// set size as large as possible
  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  /// draws a single candle
  void paintCandle(PaintingContext context, Offset offset, int index,
      Candle candle, double range) {
    Color color = candle.isBull ? _bullColor : _bearColor;

    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double x = size.width + offset.dx - (index + 0.5) * _candleWidth;

    context.canvas.drawLine(
      Offset(x, offset.dy + (_high - candle.high) / range),
      Offset(x, offset.dy + (_high - candle.low) / range),
      paint,
    );

    final double openCandleY = offset.dy + (_high - candle.open) / range;
    final double closeCandleY = offset.dy + (_high - candle.close) / range;

    if ((openCandleY - closeCandleY).abs() > 1) {
      context.canvas.drawLine(
        Offset(x, openCandleY),
        Offset(x, closeCandleY),
        paint..strokeWidth = _candleWidth * 0.8,
      );
    } else {
      // if the candle body is too small
      final double mid = (closeCandleY + openCandleY) / 2;
      context.canvas.drawLine(
        Offset(x , mid - 0.5),
        Offset(x, mid + 0.5),
        paint..strokeWidth = _candleWidth * 0.8,
      );
    }
  }

  void paintLine(PaintingContext context, Offset offset) {
    if (_candles.isEmpty) return;

    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final double chartWidth = size.width;
    final double chartHeight = size.height;
    final double priceMin = _candles.map((c) => c.close).reduce((a, b) =>
    a < b
        ? a
        : b);
    final double priceMax = _candles.map((c) => c.close).reduce((a, b) =>
    a > b
        ? a
        : b);
    final double priceRange = priceMax - priceMin;

    final double spacing = chartWidth / (_candles.length - 1);

    List<Offset> points = _candles.mapIndexed((index, candle) {
      double x = index * spacing;
      double y = chartHeight -
          ((candle.close - priceMin) / priceRange) * chartHeight;
      return Offset(x, y);
    }).toList();

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    context.canvas.drawPath(path, paint);
  }
  @override
  void paint(PaintingContext context, Offset offset) {
    if(_isLine){
      paintLine(context, offset);
    }else {
      double range = (_high - _low) / size.height;
      for (int i = 0; (i + 1) * _candleWidth < size.width; i++) {
        if (i + _index >= _candles.length || i + _index < 0) continue;
        var candle = _candles[i + _index];
        paintCandle(context, offset, i, candle, range);
      }
    }
     _close = _candles[0].close;
    context.canvas.save();
    context.canvas.restore();
  }
}
extension on List<Candle> {
  Iterable<T> mapIndexed<T>(T Function(int index, Candle candle) f) sync* {
    for (int i = 0; i < this.length; i++) {
      yield f(i, this[i]);
    }
  }
}