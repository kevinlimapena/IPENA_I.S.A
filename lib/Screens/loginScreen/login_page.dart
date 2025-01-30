import 'dart:convert';

import 'package:fcc/Screens/homescreen/HomeNew.dart';
import 'package:fcc/Screens/homescreen/menu.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late final TextEditingController _userController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  bool isLoading = false;
  _obterVersao() async {
    var versao = await VersionUtils.getVersion();

    setState(() {
      _versao = versao;
    });
  }

  String _versao = '?';
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _obterVersao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                baseColor: Colors.blueAccent,
                spawnMinSpeed: 10.0,
                spawnMaxSpeed: 50.0,
                spawnMinRadius: 7.0,
                spawnMaxRadius: 15.0,
                particleCount: 80,
              ),
            ),
            vsync: this,
            child: Container(),
          ),
          Center(
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userController,
                    onSubmitted: (value) async {
                      await loginold();
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onSubmitted: (value) async {
                      await loginold();
                    },
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await loginold();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  const SizedBox(height: 20),
                  // TextButton(
                  //   onPressed: () {
                  //     // Função de recuperação de senha
                  //   },
                  //   child: const Text(
                  //     'Esqueceu a senha?',
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // TextButton(
                  //   onPressed: () {
                  //     // Função de cadastro
                  //   },
                  //   child: const Text(
                  //     'Não tem uma conta? Se registre',
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),

                  const SizedBox(
                      height: 20), // Add some space before the version
                  Text(
                    'V.$_versao', // Replace with your app version
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  loginold() {
    setState(() {
      isLoading = true;
    });
    // Simulando o processo de login
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: _userController.text,
            senha: _passwordController.text,
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final String url = 'http://192.168.0.6:80/REST/api/oauth2/v1/token';
    final String username = _userController.text.trim();
    final String password = _passwordController.text.trim();

    // Validação básica dos campos de entrada
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
      });
      _showMessage(context, 'Usuário e senha são obrigatórios.',
          'Por favor, insira seu nome de usuário e senha.', 'Aviso');
      return;
    }

    // Codificação do usuário e senha para autenticação básica
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type':
              'application/x-www-form-urlencoded', // Mudei para application/x-www-form-urlencoded
          'Authorization': basicAuth,
        },
        body: {
          'grant_type': 'password', // Adicionei o parâmetro grant_type
          'username': username,
          'password': password,
        },
      );

      // Verifica se a requisição foi bem-sucedida
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navega para a próxima tela
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: username,
              senha: password,
            ),
          ),
        );
      } else {
        // Trata a resposta de erro
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String mensagem = responseBody['message'] ?? 'Erro desconhecido';
        _showMessage(
          context,
          mensagem,
          mensagem,
          'Aviso',
        );
      }
    } catch (e) {
      // Ocorreu um erro durante a solicitação POST
      print('Erro durante a requisição POST: $e');

      _showMessage(
        context,
        'Erro de conexão',
        'Não foi possível conectar ao servidor. Por favor, tente novamente mais tarde.',
        'Aviso',
      );
    } finally {
      setState(() {
        isLoading =
            false; // Garante que o loading seja desativado em qualquer situação
      });
    }
  }

  void _showMessage(
      BuildContext context, String action, String responseData, String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(responseData),
            ],
          ),
          contentPadding: const EdgeInsets.all(16.0),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class VersionUtils {
  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
