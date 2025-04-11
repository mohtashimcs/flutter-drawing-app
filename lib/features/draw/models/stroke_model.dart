import 'dart:ui';

import 'package:hive/hive.dart';

import 'custom_offset.dart';

part 'stroke_model.g.dart';

@HiveType(typeId: 1)
class Stroke{
  @HiveField(0)
  final List<CustomOffset> points;

  @HiveField(1)
  final int color;

  @HiveField(2)
  final double brushSize;

  Stroke({required this.points, required  this.color, required this.brushSize});

  List<Offset> get offsetPoints => points.map((e) => e.toOffset()).toList();
  Color get strokeColor => Color(color);

  factory Stroke.fromOffsets({
    required List<Offset> points,
    required Color color,
    required double brushSize,
}){
    return Stroke(points: points.map((e) => CustomOffset.fromOffset(e)).toList(), color: color.value, brushSize: brushSize);
  }

}