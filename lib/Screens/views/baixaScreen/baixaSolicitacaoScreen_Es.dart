import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import 'baixaSolicitacaoScreen.dart';

class Subbaixa extends StatefulWidget {
  final List<Map<String, dynamic>> dados;
  final String solicitante;
  final String solicitacao;
  final String user;
  final String senha;
  final Function(int) onIndexChanged;
  const Subbaixa(
      {super.key,
      required this.dados,
      required this.solicitante,
      required this.solicitacao,
      required this.user,
      required this.senha,
      required this.onIndexChanged});

  @override
  State<Subbaixa> createState() => _SubbaixaState();
}

class _SubbaixaState extends State<Subbaixa> {
  late List<Map<String, dynamic>> _dadosFiltrados;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _dadosFiltrados = widget.dados
        .where((item) => item['Solicitacao'] == widget.solicitacao)
        .toList();

    _controllers = List.generate(
      _dadosFiltrados.length,
      (index) => TextEditingController(
        text: _dadosFiltrados[index]['Qtd Solic']?.toString() ?? '0',
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showProdutoDialog(String produto) async {
    final imageBytes = await _fetchImage(produto);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Produto: $produto'),
          content: imageBytes != null
              ? Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(imageBytes),
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : const Text('Imagem não disponível'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Voltar'),
            ),
          ],
        );
      },
    );
  }

  Future<Uint8List?> _fetchImage(String produto) async {
    String username = widget.user;
    ;
    String password = widget.senha;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final url =
        'http://192.168.0.6:80/REST/ipena_insol/mt010images?product=$produto';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'authorization': basicAuth},
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void _validarEAtualizar(int index, String value) {
    final maxQtd = _dadosFiltrados[index]['Qtd Solic'] ?? 0;
    final qtd = int.tryParse(value) ?? 0;

    if (qtd >= 0 && qtd <= maxQtd) {
      setState(() {
        _dadosFiltrados[index]['Qtd Entregue'] = qtd;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Valor Inserido Maior que o Valor Solicitado : ${maxQtd.toString()}')),
      );
      _controllers[index].text =
          _dadosFiltrados[index]['Qtd Entregue']?.toString() ?? '0';
    }
  }

  Future<void> _enviarDados() async {
    // Obtém a solicitação e o centro de custo do primeiro item, se houver
    final String solicitacao =
        _dadosFiltrados.isNotEmpty ? _dadosFiltrados[0]['Solicitacao'] : '';
    final String centroDeCusto =
        _dadosFiltrados.isNotEmpty ? _dadosFiltrados[0]['Centro de custo'] : '';

    // Mapeia os itens para o novo formato
    final List<Map<String, dynamic>> bxsa = _dadosFiltrados.map((item) {
      return {
        "Item": item['Item'],
        "Codigo": item['Codigo'],
        "Endereco": "",
        "Qtd": item['Qtd Solic'],
        "Almox": item['Almox'],
      };
    }).toList();

    // Cria o novo JSON com a estrutura desejada
    final Map<String, dynamic> novoJson = {
      "Solicitacao": solicitacao,
      "Centro de Custo": centroDeCusto,
      "BXSA": bxsa,
    };

    print(jsonEncode(novoJson));

    // Exibe o diálogo de carregamento
    _showLoadingDialog(context, 'Processando...');

    try {
      final url = Uri.parse('http://192.168.0.6:80/rest/ipena_insol/BAIXASA');
      final username = widget.user;
      final password = widget.senha;
      final basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(novoJson),
      );
      print("Dados enviados: ${jsonEncode(novoJson)}");

      // Fecha o diálogo de carregamento
      Navigator.of(context).pop();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String sucessomessage = responseBody['note'] ?? 'Erro desconhecido';

        _showAlertDialogSus(
          context,
          'Sucesso',
          'Dados enviados com sucesso! $sucessomessage',
          Colors.green,
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar solicitações.')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      // Fecha o diálogo de carregamento em caso de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar solicitações.')),
      );
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  void _showAlertDialogSus(
      BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: color),
          ),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarBaixar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Você deseja baixar as solicitações?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _enviarDados();
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitante: ${widget.solicitante}"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
              });
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          GestureDetector(
            onTap: () {
              _confirmarBaixar();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 33, 243, 51), // Cor de fundo do container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: const Text(
                    'Baixar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columnSpacing: 50,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.grey.shade200,
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                dataTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                columns: const [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Código')),
                  DataColumn(label: Text('Centro de Custo')),
                  DataColumn(label: Text('Endereco')),
                  DataColumn(label: Text('Descrição')),
                  DataColumn(label: Text('Saldo')), //novocampo
                  DataColumn(label: Text('Qtd Solic')),

                  DataColumn(label: Text('Qtd Entregue')),
                ],
                rows: List<DataRow>.generate(
                  _dadosFiltrados.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text(_dadosFiltrados[index]['Item'] ?? '')),
                      DataCell(
                        Text(
                          _dadosFiltrados[index]['Codigo'] ?? '',
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        onTap: () => _showProdutoDialog(
                          _dadosFiltrados[index]['Codigo'],
                        ),
                      ),
                      DataCell(Text(
                          _dadosFiltrados[index]['Centro de Custo'] ?? '')),
                      DataCell(Text(_dadosFiltrados[index]['Endereco'] ?? '')),
                      DataCell(Text(_dadosFiltrados[index]['Descricao'] ?? '')),
                      DataCell(Text(
                          _dadosFiltrados[index]['Saldo'].toString() ?? '')),
                      DataCell(Text(
                          _dadosFiltrados[index]['Qtd Solic']?.toString() ??
                              '')),
                      DataCell(
                        TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                              _validarEAtualizar(index, value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
