import 'dart:typed_data';
import 'dart:ui';
import 'package:drawing_app/features/draw/models/stroke_model.dart';
import 'package:flutter/material.dart';

Future<Uint8List> generateThumbnail (List<Stroke> strokes, double width, double height) async{
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0,0, width, height));
  final paint = Paint()
        ..color = Colors.grey[350]!
        ..style = PaintingStyle.fill;

  //Fill the canvas with a white grey
  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  //Draw strokes onto the canvas
  for(final stroke in strokes){
    final strokePaint = Paint()
        ..color = stroke.strokeColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.brushSize;

    final points = stroke.offsetPoints;
    for(int i = 0; i<points.length - 1; i++){
      if(points[i] != Offset.zero && points[i+1] != Offset.zero){
        canvas.drawLine(points[i], points[i+1], strokePaint);
      }
    }
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(width.toInt(), height.toInt());
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}