import 'dart:typed_data' show Float32List;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../emulator/graphics/ppu.dart';
import '../utils/color_converter.dart';
import './main_screen.dart';

class LCDWidget extends StatefulWidget {
  LCDWidget({Key? key}) : super(key: key);

  @override
  State<LCDWidget> createState() {
    return MainScreen.lcdState;
  }
}

class LCDState extends State<LCDWidget> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        isComplex: true, willChange: true, painter: LCDPainter());
  }
}

/// LCD painter is used to copy the LCD data from the gameboy PPU to the screen.
class LCDPainter extends CustomPainter {
  /// Indicates if the LCD is drawing content
  bool drawing = false;

  LCDPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (MainScreen.emulator.cpu == null) {
      return;
    }

    this.drawing = true;

    int scale = 1;
    int width = PPU.LCD_WIDTH * scale;
    int height = PPU.LCD_HEIGHT * scale;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        Paint color = Paint();
        color.style = PaintingStyle.stroke;
        color.strokeWidth = 1.0;

        color.color = ColorConverter.toColor(MainScreen.emulator.cpu!.ppu
            .current[(x ~/ scale) + (y ~/ scale) * PPU.LCD_WIDTH]);

        var points = <double>[];
        points.add(x.toDouble() - width / 2.0);
        points.add(y.toDouble() + 10);

        canvas.drawRawPoints(
            PointMode.points, Float32List.fromList(points), color);
      }
    }

    this.drawing = false;
  }

  @override
  bool shouldRepaint(LCDPainter oldDelegate) {
    return !this.drawing;
  }
}
