import 'package:flutter/material.dart';

import 'baixaSolicitacaoScreen.dart';
import 'baixaSolicitacaoScreen_Es.dart';

class Baixahome extends StatefulWidget {
  final String user;

  final String senha;

  const Baixahome({
    required this.user,
    required this.senha,
    super.key,
  });

  @override
  State<Baixahome> createState() => _EnterhomeState();
}

String texto = '';

class _EnterhomeState extends State<Baixahome> {
  int selectedIndex = 0;

  void _onIndexChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _updateTexto(String newTexto) {
    setState(() {
      texto = newTexto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return baixaSolicitacaoScreen(
            onIndexChanged: _onIndexChanged,
            user: widget.user,
            senha: widget.senha,
            updateTexto: _updateTexto,
            texto: texto);
      case 1:
        return Subbaixa(
          onIndexChanged: _onIndexChanged,
          dados: [],
          solicitante: '',
          solicitacao: '',
          user: '',
          senha: '',
        );
      default:
        return baixaSolicitacaoScreen(
          onIndexChanged: _onIndexChanged,
          user: widget.user,
          senha: widget.senha,
          updateTexto: _updateTexto,
          texto: texto,
        );
    }
  }
}
