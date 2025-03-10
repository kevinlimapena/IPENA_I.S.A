import 'package:flutter/material.dart';

class Enterscreen extends StatefulWidget {
  final Function(int) onIndexChanged;

  const Enterscreen({super.key, required this.onIndexChanged});

  @override
  State<Enterscreen> createState() => _EnterscreenState();
}

class _EnterscreenState extends State<Enterscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tela fora'),
        leading: IconButton(
          onPressed: () {
            widget.onIndexChanged(1); // Altera o índice para 1
          },
          icon: Icon(Icons.hail),
        ),
      ),
    );
  }
}
