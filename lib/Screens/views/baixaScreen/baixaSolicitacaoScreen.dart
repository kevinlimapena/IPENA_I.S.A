import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:fcc/Screens/views/baixaScreen/baixaSolicitacaoScreen_Es.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class baixaSolicitacaoScreen extends StatefulWidget {
  final String user;
  final String senha;

  const baixaSolicitacaoScreen(
      {super.key, required this.user, required this.senha});
  @override
  _baixaSolicitacaoScreenState createState() => _baixaSolicitacaoScreenState();
}

class _baixaSolicitacaoScreenState extends State<baixaSolicitacaoScreen> {
  List<Map<String, dynamic>> _dados = [];
  List<Map<String, dynamic>> _dadosFiltrados = [];
  List<bool> _selectedRows = [];
  bool _isLoading = true;
  late double width;
  @override
  void initState() {
    super.initState();
    _fetchData();
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// Dimensions in physical pixels (px)
    Size size = view.physicalSize;
    double largura = size.width;

    setState(() {
      width = largura;
    });
  }

  void _applyFilter() {
    setState(() {
      // Garantir que apenas um item por solicitante seja mantido
      final solicitantesVistos = <String>{};
      _dadosFiltrados = _dados.where((item) {
        final solicitante = item['Solicitacao']?.trim() ?? '';
        if (solicitantesVistos.contains(solicitante)) {
          return false;
        }
        solicitantesVistos.add(solicitante);
        return true;
      }).toList();

      // Atualizar _selectedRows para coincidir com _dadosFiltrados
      _selectedRows = List.generate(_dadosFiltrados.length, (index) => false);
    });
  }

  // Função para buscar dados da API
  Future<void> _fetchData() async {
    final username = 'IPENA';
    final password = 'Nina@2010';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    const String url =
        'http://yamadalomfabricacao123875.protheus.cloudtotvs.com.br:4050/rest/IPENA_INSOL/BUSCASA';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': basicAuth},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('Dados')) {
          final List<dynamic> dados = jsonResponse['Dados'];
          print(dados);
          setState(() {
            _dados = dados.cast<Map<String, dynamic>>();
            _selectedRows = List<bool>.filled(_dados.length, false);
            _isLoading = false;
            _applyFilter();
            print(_dadosFiltrados);
          });
        } else {
          _showError('Erro: Dados não encontrados na resposta.');
        }
      } else {
        _showError('Erro: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Erro ao buscar dados: $e');
    }
  }

  Future<void> fetchDataof() async {
    setState(() {
      _isLoading = true;
    });

    // Dados offline simulados
    const String offlineData = '''
  {
      "Dados": [
          {
              "Solicitacao": "000002",
              "Item": "01",
              "Codigo": "MRO0003",
              "Descricao": "ETIQUETA ZEBRA  ALMOXARIFADO",
              "Um": "UN",
              "Qtd Solic": 1,
              "Almox": "05",
              "Centro de custo": "         ",
              "Solicitante": "ILTON                    ",
              "Qtd Entregue": 0,
              "Status SC": " "
          },
          {
              "Solicitacao": "000004",
              "Item": "01",
              "Codigo": "MRO0003",
              "Descricao": "ETIQUETA ZEBRA  ALMOXARIFADO",
              "Um": "UN",
              "Qtd Solic": 1,
              "Almox": "02",
              "Centro de custo": "         ",
              "Solicitante": "IPENA                    ",
              "Qtd Entregue": 0,
              "Status SC": " "
          }
      ]
  }
  ''';

    try {
      final Map<String, dynamic> jsonResponse = json.decode(offlineData);
      if (jsonResponse.containsKey('Dados')) {
        final List<dynamic> dados = jsonResponse['Dados'];
        setState(() {
          _dados = dados.cast<Map<String, dynamic>>();
          _selectedRows = List<bool>.filled(_dados.length, false);
          _isLoading = false;
          _applyFilter();
        });
      } else {
        _showError('Erro: Dados offline não encontrados.');
      }
    } catch (e) {
      _showError('Erro ao carregar dados offline: $e');
    }
  }

  // Função para exibir mensagens de erro
  void _showError(String message) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Função para enviar dados selecionados
  void _sendSelectedRows() {
    final selectedData = _dados
        .asMap()
        .entries
        .where((entry) => _selectedRows[entry.key])
        .map((entry) => entry.value)
        .toList();

    // Aqui você pode fazer um POST ou qualquer outro processamento com os dados
    print('Dados selecionados: $selectedData');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${selectedData.length} item(ns) enviado(s).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Baixa Solicitação',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 4,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _selectedRows.any((isSelected) => isSelected)
                        ? _sendSelectedRows
                        : null,
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
                ],
              ),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _dados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 80, color: Colors.redAccent),
                        const SizedBox(height: 10),
                        const Text(
                          'Erro ao carregar dados.',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _fetchData,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text('Tentar Novamente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: fetchDataof,
                          icon: const Icon(Icons.offline_bolt,
                              color: Colors.white),
                          label: const Text('Usar dados offline'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListViewer());
  }

  Widget ListViewer() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lista de Solicitações',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: width / (8),
                        headingRowColor: WidgetStateColor.resolveWith(
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
                        columns: [
                          DataColumn(label: Text('Selecionar')),

                          DataColumn(
                            label: GestureDetector(
                              onTap: () {},
                              child: Text('Solicitante'),
                            ),
                          ),
                          // DataColumn(label: Text('Item')),
                          // DataColumn(label: Text('Código')),
                          //  DataColumn(label: Text('Descrição')),
                          //  DataColumn(label: Text('UM')),
                          // DataColumn(label: Text('Qtd Solic')),
                          //  DataColumn(label: Text('Almox')),
                          DataColumn(label: Text('Centro de Custo')),
                          DataColumn(label: Text('Solicitação')),
                          // DataColumn(label: Text('Qtd Entregue')),
                          //  DataColumn(label: Text('Status SC')),
                        ],
                        rows: List<DataRow>.generate(
                          _dadosFiltrados
                              .length, // Usar _dadosFiltrados em vez de _dados
                          (index) => DataRow(
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: _selectedRows.length > index
                                      ? _selectedRows[index]
                                      : false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (_selectedRows.length > index) {
                                        _selectedRows[index] = value ?? false;
                                      }
                                    });
                                  },
                                ),
                              ),

                              DataCell(
                                Text(_dadosFiltrados[index]['Solicitante'] ??
                                    ''),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Subbaixa(
                                        dados: _dados,
                                        solicitante: _dadosFiltrados[index]
                                            ['Solicitante'],
                                        solicitacao: _dadosFiltrados[index]
                                            ['Solicitacao'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // DataCell(Text(_dadosFiltrados[index]['Item'] ?? '')),
                              // DataCell(
                              //   Text(
                              //     _dadosFiltrados[index]['Codigo'] ?? '',
                              //     style: TextStyle(color: Colors.blueGrey),
                              //   ),
                              //   onTap: () => _showProdutoDialog(
                              //     _dadosFiltrados[index]['Codigo'],
                              //   ),
                              // ),
                              // DataCell(Text(_dadosFiltrados[index]['Descricao'] ?? '')),
                              //   DataCell(Text(_dadosFiltrados[index]['Um'] ?? '')),
                              // DataCell(
                              //   Text(
                              //     _dadosFiltrados[index]['Qtd Solic']?.toString() ?? '',
                              //   ),
                              // ),
                              // DataCell(Text(_dadosFiltrados[index]['Almox'] ?? '')),
                              DataCell(Text(_dadosFiltrados[index]
                                      ['Centro de custo'] ??
                                  '')),
                              DataCell(Text(
                                  _dadosFiltrados[index]['Solicitacao'] ?? '')),
                              // DataCell(
                              //   Text(
                              //     _dadosFiltrados[index]['Qtd Entregue']?.toString() ?? '',
                              //   ),
                              // ),
                              //  DataCell(Text(_dadosFiltrados[index]['Status SC'] ?? '')),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
