import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Certifique-se de que o caminho do pacote está correto para o seu projeto.
// Se o nome do seu projeto no pubspec.yaml for 'erp_simples', mantenha assim.
import 'package:erp_simples/firebase_options.dart';

// Importações das páginas
import 'home.dart';
import 'client_page.dart';
import 'service_page.dart';
import 'delivery_page.dart';

void main() async {
  // 1. Garante que o motor do Flutter esteja pronto antes de chamar código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Erro ao inicializar Firebase: $e');
  }

  // 3. Roda o aplicativo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ERP Simples',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Define a rota inicial
      initialRoute: '/login',
      // Mapa de Rotas
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/clientes': (context) => const ClientPage(),
        '/servicos': (context) => const ServicePage(),
        '/entregas': (context) => const DeliveryPage(),
      },
    );
  }
}

// Tela de Login Simples
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Boas vindas!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(labelText: "Login"),
                    ),
                    const SizedBox(height: 15),
                    const TextField(
                      decoration: InputDecoration(labelText: "Senha"),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navega para a Home e remove o Login da pilha de volta
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Entrar"),
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
