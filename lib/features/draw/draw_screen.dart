import 'package:drawing_app/features/draw/models/stroke_model.dart';
import 'package:flutter/material.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<Stroke> _strokes = [];
  List<Stroke> _redoStrokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = Colors.black;
  double _brushSize = 4.0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Draw your dreams'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanUpdate: (details){
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanEnd: (details){
                setState(() {
                  _strokes.add(
                    Stroke(points: List.from(_currentPoints), color: _selectedColor, brushSize: _brushSize)
                  );
                  _currentPoints = [];
                  _redoStrokes = [];
                });
              },
              child: CustomPaint(
                painter: DrawPainter(
                  strokes: _strokes,
                  currentPoints: _currentPoints,
                  currentColor: _selectedColor,
                  currentBrushSize: _brushSize,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.grey[400],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // Undo Button
          IconButton(onPressed: _strokes.isNotEmpty ? (){
            setState(() {
              _redoStrokes.add(_strokes.removeLast());
            });
          } : null, icon: Icon(Icons.undo)),

          // Redo Button
          IconButton(onPressed: _strokes.isNotEmpty ? (){
            setState(() {
              _strokes.add(_redoStrokes.removeLast());
            });
          } : null, icon: Icon(Icons.redo)),

          //Brush Size Dropdown
          DropdownButton(
              value: _brushSize, 
              items: [
                DropdownMenuItem(
                    value: 2.0,
                    child: Text('Small')
                ),
                DropdownMenuItem(
                    value: 4.0,
                    child: Text('Medium')
                ),
                DropdownMenuItem(
                    value: 8.0,
                    child: Text('Large')
                ),
              ], 
              onChanged: (value){
                setState(() {
                  _brushSize = value!;
                });
              }),

          //Color Picker
          Row(
            children: [
              _buildColorButton(Colors.black),
              _buildColorButton(Colors.red),
              _buildColorButton(Colors.blue),
              _buildColorButton(Colors.green),
              _buildColorButton(Colors.yellow)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color){
    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.grey : Colors.transparent
          )
        ),
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentBrushSize;


  DrawPainter({super.repaint, required this.strokes, required this.currentPoints, required this.currentColor, required this.currentBrushSize});

  @override
  void paint(Canvas canvas, Size size) {
    //Draw completed stroke
    for(final stroke in strokes){
      final paint = Paint()
          ..color = stroke.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = stroke.brushSize;

      for (int i=0; i< stroke.points.length-1; i++){
        if(stroke.points[i] != Offset.zero && stroke.points[i+1] != Offset.zero){
          canvas.drawLine(stroke.points[i], stroke.points[i+1], paint);
        }
      }
    }

    // Draw the current active stroke
    final paint = Paint()
      ..color = currentColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = currentBrushSize;
    for (int i=0; i< currentPoints.length-1; i++){
      if(currentPoints[i] != Offset.zero && currentPoints[i+1] != Offset.zero){
        canvas.drawLine(currentPoints[i], currentPoints[i+1], paint);
      }
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

