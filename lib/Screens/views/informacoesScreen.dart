import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'dart:ui';
import 'package:path_provider/path_provider.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: clipper(),
              child: Container(
                padding: const EdgeInsets.all(0),
                color: Colors.blueAccent,
                child: SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      Positioned(
                          top: -150,
                          right: -250,
                          child: CircularContainer(
                            color: Colors.purple.shade800.withOpacity(0.2),
                          )),
                      Positioned(
                          top: 100,
                          right: -300,
                          child: CircularContainer(
                            color: Colors.purple.shade800.withOpacity(0.2),
                          )),
                      Positioned(
                          top: -100,
                          right: 300,
                          child: CircularContainer(
                            color: Colors.purple.shade800.withOpacity(0.2),
                          )),
                      Positioned(
                          top: 150,
                          right: 250,
                          child: CircularContainer(
                            color: Colors.purple.shade800.withOpacity(0.2),
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/Prancheta 2.png",
                              height: 250,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'App I.S.A',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              height: 300,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.blueAccent,
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width * .45,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.question_answer_outlined),
                        ),
                        const Text(
                          "Alguma sugestão ou Melhoria?",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                        ),
                        const Text(
                          "ipenaconsult@gmail.com",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * .45,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.blueAccent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.question_mark_outlined),
                        ),
                        const Text(
                          "Como seus dados estão sendo salvos?",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                        ),
                        const Text(
                          "ipenaconsult@gmail.com",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PoliticaPrivacidade()),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text(
                "Políticas de Privacidade",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  "Projeto do Aplicativo da fábrica, Desenvolvido pela Ipenaconsultoria"),
            )
          ],
        ),
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.color = Colors.white,
    this.child,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: child,
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

class clipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    var controllPoint = Offset(10, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
    var controllPoint2 = Offset(size.width - 10, size.height);
    var endPoint2 = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
        controllPoint2.dx, controllPoint2.dy, endPoint2.dx, endPoint2.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
// Tela de Política de Privacidade

class PoliticaPrivacidade extends StatefulWidget {
  const PoliticaPrivacidade({Key? key}) : super(key: key);

  @override
  _PoliticaPrivacidadeScreenState createState() =>
      _PoliticaPrivacidadeScreenState();
}

class _PoliticaPrivacidadeScreenState extends State<PoliticaPrivacidade> {
  final List<String> _imagePaths = [
    "assets/page001.jpg",
    "assets/page002.jpg",
    "assets/page003.jpg",
    "assets/page004.jpg",
    "assets/page005.jpg",
    "assets/page006.jpg",
    "assets/page007.jpg",
  ];
  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
    });
  }

  void _previousImage() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _imagePaths.length) % _imagePaths.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Política de Privacidade")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: Image.asset(
              _imagePaths[_currentIndex],
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 32),
              onPressed: _previousImage,
            ),
          ),
          Positioned(
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 32),
              onPressed: _nextImage,
            ),
          ),
        ],
      ),
    );
  }
}
