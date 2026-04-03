import 'package:flutter/material.dart';

class ToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Инструменты", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Вернуться назад
          },
        ),
      ),
      body: Center(
        child: const Text(
          "Здесь будет список инструментов",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
