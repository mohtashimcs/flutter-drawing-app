import 'package:drawing_app/features/draw/models/stroke_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<List<Stroke>> _drawingBox;

  @override
  void initState() {
    _initializeHive();
    super.initState();
  }

  Future<void> _initializeHive() async {
    // await Hive.deleteFromDisk();
    _drawingBox = Hive.box<List<Stroke>>('drawings');
  }

  @override
  Widget build(BuildContext context) {
    final drawingNames = _drawingBox.keys.cast<String>().toList();
    return Scaffold(
      appBar: AppBar(title: Text('My Drawings')),
      body:
          drawingNames.isEmpty
              ? const Center(child: Text('No drawing saved yet.'))
              : GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: drawingNames.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final name = drawingNames[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/draw', arguments: name);
                    },
                    child: Card(
                      elevation: 4,
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/draw');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
