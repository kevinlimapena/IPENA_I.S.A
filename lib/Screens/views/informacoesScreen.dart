import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
 
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

 
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override

  Future<void> _openPDF() async {
    const pdfFileName = 'politicadeprivacidadeFCC.pdf';

    try {
      // Obtenha o caminho do arquivo no app
      final byteData = await rootBundle.load('assets/$pdfFileName');
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$pdfFileName';
      final file = File(filePath);

      // Escreve o arquivo temporário
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Abre o arquivo com o leitor externo padrão
      final fileUri = Uri.file(file.path);
      if (await canLaunchUrl(fileUri)) {
        await launchUrl(fileUri);
      } else {
        throw 'Não foi possível abrir o PDF.';
      }
    } catch (e) {
      debugPrint('Erro ao abrir PDF: $e');
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Espaçamento para posicionar o conteúdo mais acima
          const SizedBox(height: 50),
          // Logo do app com o nome ao lado, alinhados no topo
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                Image.asset(
                  "assets/logo.png",
                  height: 50,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Aplicação FCC',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Texto informando quem desenvolveu
          const Text(
            'Projeto do Aplicativo da fábrica, Desenvolvido pela Ipenaconsultoria',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          // Informações de contato
          const ContactInfoRow(
            icon: Icons.email,
            label: 'Dúvidas/Sugestões:',
            email: 'ipenaconsult@gmail.com',
          ),
          const SizedBox(height: 15),
          const ContactInfoRow(
            icon: Icons.email,
            label: 'Informações sobre meus dados:',
            email: 'ipenaconsult@gmail.com',
          ),
          const Spacer(),
          // Botão de Política de Privacidade alinhado no centro
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  _openPDF();
                  // Navegar para a tela de Política de Privacidade
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const PDFViewerScreen(),
                  //   ),
                  // );
                },
                child: const Text("Política de Privacidade"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar as informações de contato com ícone
class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String email;

  const ContactInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          '$label $email',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

// Tela de Política de Privacidade
class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(child: SfPdfViewer.asset('assets/politicadeprivacidadeFCC.pdf')),
    );
  }
}

  