import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math.dart' as v;

// Look Ma NO WIDGET in Flutter !!!
class Colored extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = v.SimplexNoise();
    final frames = 200;
    canvas.drawPaint(Paint()..color = Colors.black87);

    for (double i = 10; i < frames; i += .1) {
      canvas.translate(i % .3, i % .6);
      canvas.save();
      canvas.rotate(pi / i * 25);

      final area = Offset(i, i) & Size(i * 10, i * 10);

      // Blue trail is made of rectangle
      canvas.drawRect(
          area,
          Paint()
            ..filterQuality =
                FilterQuality.high // Change this to lower render time
            ..blendMode =
                BlendMode.screen // Remove this to see the natural drawing shape
            ..color =
                // Addition of Opacity gives you the fading effect from dark to light
                Colors.blue.withRed(i.toInt() * 20 % 11).withOpacity(i / 850));

      // Tail particles effect

      // Change this to add more fibers
      final int tailFibers = (i * 1.5).toInt();

      for (double d = 0; d < area.width; d += tailFibers) {
        for (double e = 0; e < area.height; e += tailFibers) {
          final n = random.noise2D(d, e);
          final tail = exp(i / 50) - 5;
          final tailWidth = .2 + (i * .11 * n);
          canvas.drawCircle(
              Offset(d, e),
              tailWidth,
              Paint()
                ..color = Colors.red.withOpacity(.4)
                ..isAntiAlias = true // Change this to lower render time
                // Particles accelerate as they fall so we change the blur size for movement effect
                ..imageFilter = ImageFilter.blur(sigmaX: tail, sigmaY: 0)
                ..filterQuality =
                    FilterQuality.high // Change this to lower render time
                ..blendMode = BlendMode
                    .screen); // Remove this to see the natural drawing shape
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
