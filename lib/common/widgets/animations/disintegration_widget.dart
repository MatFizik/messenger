import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DisintegrationWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onDisintegrated;
  final Color particleColor;

  const DisintegrationWidget({
    super.key,
    required this.child,
    required this.onDisintegrated,
    this.particleColor = Colors.grey,
  });

  @override
  State<DisintegrationWidget> createState() => DisintegrationWidgetState();
}

class DisintegrationWidgetState extends State<DisintegrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> _particles = [];
  bool _isDisintegrating = false;
  final Random _random = Random();
  Size? _capturedSize;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.update();
        }
      });
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDisintegrated();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> disintegrate() async {
    if (_isDisintegrating) return;

    final boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;

    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return;

    final width = image.width;
    final height = image.height;
    final bytes = byteData.buffer.asUint8List();

    _capturedSize = Size(width.toDouble(), height.toDouble());
    _particles.clear();

    const int step = 1; // Sampling step

    for (int y = 0; y < height; y += step) {
      for (int x = 0; x < width; x += step) {
        final int offset = (y * width + x) * 4;
        if (offset + 3 >= bytes.length) continue;

        final int r = bytes[offset];
        final int g = bytes[offset + 1];
        final int b = bytes[offset + 2];
        final int a = bytes[offset + 3];

        if (a > 0) {
          _particles.add(Particle(
            x: x.toDouble(),
            y: y.toDouble(),
            dx: (_random.nextDouble() - 0.5) * 2,
            dy: -_random.nextDouble() * 2 - 0.5,
            size: step.toDouble(),
            color: Color.fromARGB(a, r, g, b),
            speed: _random.nextDouble() * 2 + 1,
          ));
        }
      }
    }

    setState(() {
      _isDisintegrating = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisintegrating) {
      return SizedBox(
        width: _capturedSize?.width,
        height: _capturedSize?.height,
        child: CustomPaint(
          painter: ParticlePainter(_particles),
        ),
      );
    }
    return RepaintBoundary(
      key: _globalKey,
      child: widget.child,
    );
  }
}

class Particle {
  double x;
  double y;
  double dx;
  double dy;
  double size;
  Color color;
  double speed;
  double opacity = 1.0;

  Particle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.size,
    required this.color,
    required this.speed,
  });

  void update() {
    x += dx * speed;
    y += dy * speed;
    opacity -= 0.015;
    if (opacity < 0) opacity = 0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      if (particle.opacity > 0) {
        final paint = Paint()
          ..color = particle.color.withValues(alpha: particle.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
