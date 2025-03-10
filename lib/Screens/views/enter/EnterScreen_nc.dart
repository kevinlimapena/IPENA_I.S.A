import 'package:flutter/material.dart';

class EnterscreenNc extends StatefulWidget {
  final Function(int) onIndexChanged;

  const EnterscreenNc({super.key, required this.onIndexChanged});

  @override
  State<EnterscreenNc> createState() => _EnterscreenNcState();
}

class _EnterscreenNcState extends State<EnterscreenNc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tela Dentro'),
        leading: IconButton(
          onPressed: () {
            widget.onIndexChanged(0); // Altera o índice para 0
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
