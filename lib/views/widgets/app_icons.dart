import 'package:flutter/material.dart';
import '../../config/colors.dart';

class AppIcons {
  static const double defaultSize = 24;

  // Logo icon (trash/waste icon)
  static Widget logo({double size = 58}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }

  // Truck/pickup icon
  static Widget truckIcon({double size = 30}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TruckPainter(),
      ),
    );
  }

  // Guide/document icon
  static Widget guideIcon({double size = 30}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GuidePainter(),
      ),
    );
  }

  // Money/balance icon
  static Widget balanceIcon({double size = 30}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BalancePainter(),
      ),
    );
  }

  static Widget locationIcon({double size = 22}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LocationPainter(),
      ),
    );
  }

  static Widget upArrowIcon({double size = 20}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _UpArrowPainter(),
      ),
    );
  }

  static Widget downArrowIcon({double size = 20}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DownArrowPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0xFFFFFFFF).withAlpha(234);
    final greenPaint = Paint()..color = AppColors.primary.withAlpha(179);

    final width = size.width;
    final height = size.height;

    canvas.drawPath(
      _createPath([
        Offset(width * 0.5, height * 0.117),
        Offset(width * 0.667, height * 0.35),
        Offset(width * 0.333, height * 0.35),
      ]),
      paint,
    );

    canvas.drawCircle(Offset(width * 0.5, height * 0.5), width * 0.133, paint);
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), width * 0.067,
        greenPaint);
  }

  Path _createPath(List<Offset> points) {
    if (points.isEmpty) return Path();
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TruckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1;

    final width = size.width;
    final height = size.height;

    canvas.drawRect(
      Rect.fromLTWH(width * 0.05, height * 0.55, width * 0.6, height * 0.35),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1;

    final width = size.width;
    final height = size.height;

    canvas.drawRect(
      Rect.fromLTWH(width * 0.15, height * 0.1, width * 0.7, height * 0.8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BalancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1.5;

    final width = size.width;
    final height = size.height;

    canvas.drawRect(
      Rect.fromLTWH(width * 0.06, height * 0.4, width * 0.88, height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LocationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    final width = size.width;
    final height = size.height;

    canvas.drawPath(
      Path()
        ..moveTo(width * 0.5, height * 0.08)
        ..cubicTo(
          width * 0.25,
          height * 0.25,
          width * 0.25,
          height * 0.5,
          width * 0.5,
          height * 0.9,
        )
        ..cubicTo(
          width * 0.75,
          height * 0.5,
          width * 0.75,
          height * 0.25,
          width * 0.5,
          height * 0.08,
        )
        ..close(),
      paint,
    );

    canvas.drawCircle(Offset(width * 0.5, height * 0.35), width * 0.15, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UpArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height;

    canvas.drawLine(
      Offset(width * 0.5, height * 0.15),
      Offset(width * 0.5, height * 0.9),
      paint,
    );

    canvas.drawLine(
      Offset(width * 0.25, height * 0.4),
      Offset(width * 0.5, height * 0.15),
      paint,
    );

    canvas.drawLine(
      Offset(width * 0.75, height * 0.4),
      Offset(width * 0.5, height * 0.15),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DownArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.error
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height;

    canvas.drawLine(
      Offset(width * 0.5, height * 0.15),
      Offset(width * 0.5, height * 0.9),
      paint,
    );

    canvas.drawLine(
      Offset(width * 0.25, height * 0.65),
      Offset(width * 0.5, height * 0.9),
      paint,
    );

    canvas.drawLine(
      Offset(width * 0.75, height * 0.65),
      Offset(width * 0.5, height * 0.9),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
