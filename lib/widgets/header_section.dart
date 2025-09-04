// lib/widgets/header_section.dart
import 'package:flutter/material.dart';
import 'gradient_title.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/isologo.png',
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 20),
        const GradientTitle(
          title: 'Contratar el servicio',
          fontSize: 48,
        ),
        const SizedBox(height: 10),
        const Text(
          'Construye tu pedido a medida y obtén una cotización al instante.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}