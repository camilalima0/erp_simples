import 'package:flutter/material.dart';
import 'service_page.dart';
import 'client_page.dart';
import 'delivery_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E73FF),
        title: const Text(
          "ONSERVICE",
          style: TextStyle(fontSize: 14, letterSpacing: 1, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Card superior com título
            Container(
              width: 280,
              padding: const EdgeInsets.symmetric(vertical: 35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  "ONSERVICE",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Botão Serviços
            buildHomeButton(
              text: "Serviços",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServicePage()),
                );
              },
            ),

            const SizedBox(height: 15),

            // Botão Clientes
            buildHomeButton(
              text: "Clientes",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClientPage()),
                );
              },
            ),

            const SizedBox(height: 15),

            // Botão Entregas
            buildHomeButton(
              text: "Entregas",
              onPressed: () {
                // Adicionando um SnackBar para provar que o clique está funcionando
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("")));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeliveryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- BOTÃO (Corrigido para usar ElevatedButton) ---
  Widget buildHomeButton({
    required String text,
    required VoidCallback onPressed, // Renomeado para onPressed
  }) {
    return ElevatedButton(
      onPressed: onPressed, // Repassa a função para o onPressed nativo
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Cor de fundo do botão
        foregroundColor: Colors.black, // Cor do texto e efeito de clique
        minimumSize: const Size(260, 40), // Define o tamanho
        maximumSize: const Size(260, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Borda arredondada
        ),
        elevation: 0, // Remove a sombra padrão
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
