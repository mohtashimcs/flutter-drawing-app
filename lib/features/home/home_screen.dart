import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Drawings'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, '/draw');
        }, child: const Text("Create New Drawing")),
      ),
    );
  }
}
