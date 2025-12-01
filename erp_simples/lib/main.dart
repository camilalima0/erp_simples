import 'package:flutter/material.dart';
import 'home.dart'; // ⭐ IMPORTA A HOME CORRETA

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ERP Simples',

      home: const LoginPage(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(), // ⭐ HOME CORRETA
      },
    );
  }
}

// ===================================================================
// LOGIN PAGE
// ===================================================================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "ONSERVICE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Botão título
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Boas vindas !",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Card com formulário
              Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Login :"),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const TextField(decoration: InputDecoration(border: InputBorder.none)),
                    ),

                    const SizedBox(height: 20),

                    const Text("Senha :"),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const TextField(
                        obscureText: true,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home'); // AGORA VAI PARA A HOME CERTA
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("enviar"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
