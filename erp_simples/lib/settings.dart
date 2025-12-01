import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Configurações"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Página de Configurações",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
