// import 'package:flutter/material.dart';

// class TextPathPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final String text = 'Hello, Flutter!';
//     final Path path = createTextPath(text, size.width);

//     final textStyle = TextStyle(
//       color: Colors.blue,
//       fontSize: 20.0,
//       fontWeight: FontWeight.bold,
//     );

//     final textPainter = TextPainter(
//       text: TextSpan(text: text, style: textStyle),
//       textDirection: TextDirection.ltr,
//     );

//     // Layout the text along the path
//     textPainter.layout();
//     final textPathMetrics = path.computeMetrics();
//     for (final metric in textPathMetrics) {
//       final offset = metric.getTangentForOffset(0)?.position ?? Offset.zero;
//       canvas.save();
//       canvas.translate(offset.dx, offset.dy);
//       // canvas.rotate(metric.angleAtOffset(0));
//       textPainter.paint(canvas, Offset.zero);
//       canvas.restore();
//     }
//   }

//   Path createTextPath(String text, double width) {
//     final path = Path();
//     final textPainter = TextPainter(
//       text: TextSpan(text: text, style: TextStyle(fontSize: 20.0)),
//       textDirection: TextDirection.ltr,
//     );

//     textPainter.layout();
//     final textPath = Path();
//     textPath.addRect(Rect.fromPoints(Offset.zero, Offset(width, 50.0)));
//     textPath.addRect(Rect.fromPoints(Offset.zero, Offset(50.0, 200.0)));

//     final scale = width / textPainter.width;
//     final matrix4 = Matrix4.identity()..scale(scale);
//     textPath.transform(matrix4.storage);
//     return textPath;
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
