import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../candlesticks.dart';

class LineChartPainter extends CustomPainter {
  final List<Candle> candles;
  final Color lineColor;
  final double lineWidth;
  final Color fillColor;
  final Color fillInsideColor;
  final double scaleX;
  final double translateX;

  Path? mLinePath;
  Path? mLineFillPath;
  Paint mLinePaint;
  Paint mLineFillPaint;
  Shader? mLineFillShader;
  Rect chartRect;

  LineChartPainter({
    required this.candles,
    this.lineColor = Colors.blue,
    this.lineWidth = 2.0,
    this.fillColor = Colors.red,
    this.fillInsideColor = Colors.grey,
    this.scaleX = 1.0,
    this.translateX = 0.0,
  })  : mLinePaint = Paint()
    ..color = lineColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = lineWidth,
        mLineFillPaint = Paint()
          ..style = PaintingStyle.fill,
        chartRect = Rect.zero;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final double chartWidth = size.width;
    final double chartHeight = size.height;
    chartRect = Rect.fromLTWH(0, 0, chartWidth, chartHeight);

    canvas.save();
    canvas.translate(translateX * scaleX, 0.0);
    canvas.scale(scaleX, 1.0);

    final double priceMin = candles.map((c) => c.close).reduce((a, b) => a < b ? a : b);
    final double priceMax = candles.map((c) => c.close).reduce((a, b) => a > b ? a : b);
    final double priceRange = priceMax - priceMin;

    final double spacing = chartWidth / (candles.length - 1);

    List<Offset> points = candles.mapIndexed((index, candle) {
      double x = index * spacing;
      double y = chartHeight - ((candle.close - priceMin) / priceRange) * chartHeight;
      return Offset(x, y);
    }).toList();

    mLinePath = Path();
    mLineFillPath = Path();

    for (int i = 1; i < points.length; i++) {
      drawPolyline(points[i - 1].dy, points[i].dy, canvas, points[i - 1].dx, points[i].dx);
    }

    canvas.restore();
  }

  double getY(double price) {
    final double chartHeight = chartRect.height;
    final double priceMin = candles.map((c) => c.close).reduce((a, b) => a < b ? a : b);
    final double priceMax = candles.map((c) => c.close).reduce((a, b) => a > b ? a : b);
    final double priceRange = priceMax - priceMin;
    return chartHeight - ((price - priceMin) / priceRange) * chartHeight;
  }

  void drawPolyline(double lastPrice, double curPrice, Canvas canvas, double lastX, double curX) {
    if (lastX == curX) lastX = 0;

    mLinePath!.moveTo(lastX, getY(lastPrice));
    mLinePath!.cubicTo((lastX + curX) / 2, getY(lastPrice), (lastX + curX) / 2, getY(curPrice), curX, getY(curPrice));

    mLineFillShader ??= LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.clamp,
      colors: [fillColor, fillInsideColor],
    ).createShader(Rect.fromLTRB(chartRect.left, chartRect.top, chartRect.right, chartRect.bottom));

    mLineFillPaint..shader = mLineFillShader;

    mLineFillPath!.moveTo(lastX, chartRect.height + chartRect.top);
    mLineFillPath!.lineTo(lastX, getY(lastPrice));
    mLineFillPath!.cubicTo((lastX + curX) / 2, getY(lastPrice), (lastX + curX) / 2, getY(curPrice), curX, getY(curPrice));
    mLineFillPath!.lineTo(curX, chartRect.height + chartRect.top);
    mLineFillPath!.close();

    canvas.drawPath(mLineFillPath!, mLineFillPaint);
    mLineFillPath!.reset();

    canvas.drawPath(mLinePath!, mLinePaint);
    mLinePath!.reset();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension on List<Candle> {
  Iterable<T> mapIndexed<T>(T Function(int index, Candle candle) f) sync* {
    for (int i = 0; i < this.length; i++) {
      yield f(i, this[i]);
    }
  }
}
