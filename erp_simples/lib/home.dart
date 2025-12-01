import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: AppBar(
        title: const Text(
          "MENU PRINCIPAL",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF1E73FF),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove botão de voltar para Login
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(context, "SERVIÇOS", '/servicos'),
            const SizedBox(height: 20),
            _buildMenuButton(context, "CLIENTES", '/clientes'),
            const SizedBox(height: 20),
            _buildMenuButton(context, "ENTREGAS", '/entregas'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, String route) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
