import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iqmap/src/home/presentation/controllers/location_providers.dart';

class UserLocationIndicator extends StatelessWidget {
  const UserLocationIndicator({super.key});

  static const double size = 96;
  static const Color color = Color(0xFF1A73E8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Consumer(
            builder: (context, ref, _) {
              final value = ref.watch(headingProvider).value;
              if (value == null) return const SizedBox.shrink();
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(end: value),
                duration: const Duration(milliseconds: 200),
                builder: (context, angle, _) => Transform.rotate(
                  angle: angle * math.pi / 180,
                  child: const CustomPaint(
                    size: Size.square(size),
                    painter: _HeadingBeamPainter(color),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeadingBeamPainter extends CustomPainter {
  const _HeadingBeamPainter(this.color);

  static const double _sweep = 70 * math.pi / 180;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: 0.55), color.withValues(alpha: 0)],
      ).createShader(rect);
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, -math.pi / 2 - _sweep / 2, _sweep, false)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeadingBeamPainter oldDelegate) =>
      oldDelegate.color != color;
}
