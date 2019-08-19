import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math.dart' as v;

class Colored extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final simplex = v.SimplexNoise();

    canvas.drawPaint(Paint()..color = Colors.black87);

    final frames = 200;

    for (double i = 10; i < frames; i += .1) {
      canvas.translate(i % .3, i % .6);
      canvas.save();
      canvas.rotate(pi / i * 25);

      final area = Offset(i, i) & Size(i * 10, i * 10);

      canvas.drawRect(
          area,
          Paint()
            ..filterQuality = FilterQuality.high
            ..blendMode = BlendMode.screen
            ..color =
                Colors.blue.withRed(i.toInt() * 20 % 11).withOpacity(i / 850));

      final int tailFibers = (i * 1).toInt();
      for (double d = 0; d < area.width; d += tailFibers) {
        for (double e = 0; e < area.height; e += tailFibers) {
          final n = simplex.noise2D(d, e);
          final tail = exp(i / 50) - 5;
          final tailWidth = .2 + (i * .11 * n);
          canvas.drawCircle(
              Offset(d, e),
              tailWidth,
              Paint()
                ..color = Colors.red.withOpacity(.4)
                ..isAntiAlias = false
                ..imageFilter = ImageFilter.blur(sigmaX: tail, sigmaY: 0)
                ..filterQuality = FilterQuality.low
                ..blendMode = BlendMode.screen);
        }
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

void main() => RenderingFlutterBinding(
      root: RenderPositionedBox(
        alignment: Alignment(.1, -.2),
        child: RenderCustomPaint(painter: Colored()),
      ),
    );
