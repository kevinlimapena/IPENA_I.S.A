import 'package:fcc/Screens/views/baixaScreen/baixaSolicitacaoScreen.dart';
import 'package:flutter/material.dart';
import '../views/solicitacaoScreen.dart'; // Importe correto do arquivo da sua tabela dinâmica.
import '../loginScreen/login_page.dart';

class HomeScreen extends StatefulWidget {
  final String user;
  final String senha;

  const HomeScreen({super.key, required this.user, required this.senha});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _confirmarSaida() {
    showDialog(
      context: context,
      builder: (ctx) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: TextTheme(
            titleLarge: Theme.of(context).textTheme.titleLarge,
            titleMedium:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
          ),
        ),
        child: AlertDialog(
          title: const Text(
              style: TextStyle(color: Colors.black, fontSize: 28),
              'Confirmação'),
          content: const Text(
              style: TextStyle(color: Colors.black, fontSize: 16),
              'Deseja mesmo fazer logoff?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('SIM'),
              onPressed: () {
                // Adicione a lógica de logout do seu Provider, se necessário
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
            TextButton(
              child: const Text('NÃO'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('FCC Do Brasil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _confirmarSaida, // Chama o método de confirmação
          ),
        ],
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: Colors.grey[200], // Cor de fundo suave
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, ${widget.user}!',
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            const Text(
              'Escolha uma das opções abaixo:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildOptionCard(
                    context,
                    title: 'Solicitação ao Armazem',
                    icon: Icons.table_chart,
                    description: ' ',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FCCApp(user: widget.user, senha: widget.senha),
                        ),
                      );
                    },
                  ),
                  _buildOptionCard(
                    context,
                    title: 'Baixa Solicitação ao Armazem',
                    icon: Icons.monetization_on,
                    description: ' ',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => baixaSolicitacaoScreen(
                              user: widget.user, senha: widget.senha),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required String title,
      required IconData icon,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Icon(icon, color: Colors.blueAccent, size: 40),
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text(description, style: const TextStyle(color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
        onTap: onTap,
      ),
    );
  }
}
