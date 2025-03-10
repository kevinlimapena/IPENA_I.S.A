import 'package:flutter/material.dart';
import 'EnterScreen.dart';
import 'EnterScreen_nc.dart';

class Enterhome extends StatefulWidget {
  const Enterhome({super.key});

  @override
  State<Enterhome> createState() => _EnterhomeState();
}

class _EnterhomeState extends State<Enterhome> {
  int selectedIndex = 0;

  void _onIndexChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return Enterscreen(onIndexChanged: _onIndexChanged);
      case 1:
        return EnterscreenNc(onIndexChanged: _onIndexChanged);
      default:
        return Enterscreen(onIndexChanged: _onIndexChanged);
    }
  }
}
