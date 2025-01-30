import 'dart:ui';

import 'package:fcc/Screens/views/informacoesScreen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:get/route_manager.dart';
import '../../Componentes/MenuItem.dart';
import '../loginScreen/login_page.dart';
import '../views/baixaScreen/baixaSolicitacaoScreen.dart';
import '../views/solicitacaoScreen.dart';

class HomeScreen extends StatefulWidget {
  final String user;
  final String senha;

  const HomeScreen({super.key, required this.user, required this.senha});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSidebarOpen = false;
  bool expendedTile = false;
  int selectedIndex = 0;
  String nome = '';
  List<dynamic> _acessoUser = [];

  late double height;

  bool _menuBudgetGeral = false;
  bool _menuBudgetPlanejado = false;
  bool _menuBudgetRealizado = false;
  bool _menuBudgetComparativo = false;

  bool _menuBudgetReceita = false;

  final Map<String, bool> isHovered = {
    'Budget': false,
    'Taxa': false,
    'Integracao': false,
    'Sair': false,
  };

  void _confirmarSaida() {
    showDialog(
      context: context,
      builder: (ctx) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: TextTheme(
            titleLarge: Theme.of(context).textTheme.titleLarge,
            titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                ),
          ),
        ),
        child: AlertDialog(
          title: RichText(
            text: const TextSpan(
              text: 'Confirmação\t',
              style: TextStyle(
                fontFamily: "Bebas",
                fontSize: 24,
                letterSpacing: 0,
              ),
            ),
          ),
          content: RichText(
            text: const TextSpan(
              text: 'Deseja mesmo fazer Logoff\t',
              style: TextStyle(
                fontFamily: "Bebas",
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actionsAlignment: MainAxisAlignment.end, // Centraliza os botões
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800], // Cor de fundo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // Cantos quadrados
                ),
                elevation: 5, // Adiciona sombra
                // Ajusta o tamanho do botão
              ),
              child: const Text(
                'Não',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor de fundo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // Cantos quadrados
                ),
                elevation: 5, // Adiciona sombra
                // Ajusta o tamanho do botão
              ),
              child: const Text(
                'Sim',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// Dimensions in physical pixels (px)
    Size size = view.physicalSize;
    double width = size.width;
    double altura = size.height;

    setState(() {
      height = altura;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: <Widget>[
          Expanded(
            child: Flexible(
              child: Row(
                children: [
                  Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: isSidebarOpen ? 250 : 70,
                        height: double.infinity,
                        color: const Color(0xFF303237),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.5),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isSidebarOpen = !isSidebarOpen;
                                  if (expendedTile) {
                                    expendedTile = !expendedTile;
                                  }
                                });
                              },
                              icon: Align(
                                alignment: isSidebarOpen
                                    ? Alignment.centerRight
                                    : Alignment.center,
                                child: const Icon(Icons.dashboard),
                              ),
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            if (isSidebarOpen)
                              RichText(
                                text: TextSpan(
                                  text: 'I.S.A\t',
                                  style: TextStyle(
                                    color: (Colors.white),
                                    fontFamily: "Bebas",
                                    fontSize: 30,
                                    letterSpacing: 5,
                                  ),
                                  children: [TextSpan(text: ' ')],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.dark_mode)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      icon: const Icon(Icons.info_outlined)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.circle_outlined)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'UserName ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontFamily: "Bebas",
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        children: [TextSpan(text: ' ')],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: isSidebarOpen ? 250 : 70,
            color: const Color(0xFF303237),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildDrawerArrowItem(
                        icon: Icons.addchart,
                        label: 'Solicitação de Produtos',
                        isOpen: isSidebarOpen,
                        onTap: () {
                          if (isSidebarOpen) {
                            setState(() {
                              expendedTile = !expendedTile;
                            });
                          } else {
                            setState(() {
                              //    isSubMenuOpen = !isSubMenuOpen; // Alterna o estado do sub-menu
                              showDialog(
                                barrierColor: Colors.black.withOpacity(0.1),
                                context: context,
                                builder: (BuildContext context) {
                                  return Stack(
                                    children: [
                                      Positioned(
                                        bottom: height /
                                            math.pi *
                                            1.6, // Distância do topo
                                        left:
                                            70, // Distância da borda esquerda (mude para `right` para o outro lado)
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: 180,
                                            height: 170,
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                  0xFF303237), // Cor de fundo
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // Cantos arredondados
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(
                                                      0, 4), // Sombra leve
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(
                                                16), // Espaçamento interno
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start, // Alinhamento dos itens
                                              children: [
                                                HoverTextButton(
                                                  text:
                                                      'Solicitação de Produtos',
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedIndex = 0;
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                ),
                                                HoverTextButton(
                                                  text: 'Baixa Solicitação',
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedIndex = 1;
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                          }
                        },
                        expanded: expendedTile,
                      ),
                      ClipRect(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          // Necessário para animações baseadas em tamanho
                          child: expendedTile
                              ? Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          HoverTextButton(
                                            text: 'Solicitação de Produtos',
                                            onPressed: () {
                                              setState(() {
                                                selectedIndex = 0;
                                              });
                                            },
                                          ),
                                          HoverTextButton(
                                            text: 'Baixa Solicitação',
                                            onPressed: () {
                                              setState(() {
                                                selectedIndex = 1;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      _buildDrawerItem(
                        icon: Icons.upload_file,
                        label: 'Integração',
                        isOpen: isSidebarOpen,
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.exit_to_app,
                        label: 'Logoff',
                        isOpen: isSidebarOpen,
                        onTap: () {
                          setState(() {
                            _confirmarSaida();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildContent(), // Exibe o conteúdo baseado no índice.
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Retorna o widget com base no índice selecionado.
    switch (selectedIndex) {
      case 0:
        return FCCApp(user: widget.user, senha: widget.senha);
      case 1:
        return baixaSolicitacaoScreen(user: widget.user, senha: widget.senha);
      case 2:
        return const InfoScreen();
      default:
        return FCCApp(user: widget.user, senha: widget.senha);
    }
  }

  void _updateHoverState(String title, bool isHovering) {
    setState(() {
      isHovered[title] = isHovering;
    });
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      onEnter: (_) => _updateHoverState(label, true),
      onExit: (_) => _updateHoverState(label, false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                isHovered[label] == true ? Colors.blue.withOpacity(0.2) : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isHovered[label] == true ? Colors.blue : Colors.white,
              ),
              if (isOpen) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color:
                          isHovered[label] == true ? Colors.blue : Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerArrowItem(
      {required IconData icon,
      required String label,
      required bool isOpen,
      required VoidCallback onTap,
      required bool expanded}) {
    return MouseRegion(
      onEnter: (_) => _updateHoverState(label, true),
      onExit: (_) => _updateHoverState(label, false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:
                isHovered[label] == true ? Colors.blue.withOpacity(0.2) : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isHovered[label] == true ? Colors.blue : Colors.white,
              ),
              if (isOpen) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: isHovered[label] == true
                              ? Colors.blue
                              : Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween<double>(
                          begin: 0,
                          end:
                              expanded ? 90 : 0, // Controla o ângulo de rotação
                        ),
                        builder: (context, angle, child) {
                          return Transform.rotate(
                            angle:
                                angle * math.pi / 180, // Converte para radianos
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: isHovered[label]!
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}




// Widgets separados para cada tela.

// MenuItem widget para reutilização no menu.


