import 'package:flutter/material.dart';

class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  // Função auxiliar para construir os campos de texto
  Widget _buildTextField({
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9), // Cor de fundo do Scaffold
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E73FF), // Cor da AppBar
        title: const Text(
          "ONSERVICE",
          style: TextStyle(fontSize: 14, letterSpacing: 1, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.settings, color: Colors.white),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    "Cliente - menu", // Título acima da área do formulário
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ),
                Center(
                  child: Container(
                    width: 320, // Largura do card branco
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Círculo para a imagem/avatar (ícone de perfil)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFFD9D9D9), // Cor cinza clara do círculo
                              // child: Icon(Icons.person, size: 40, color: Colors.grey[700]), // Opcional: ícone dentro
                            ),
                          ),
                        ),

                        // Campos de Texto
                        _buildTextField(labelText: 'Nome completo', keyboardType: TextInputType.name),
                        const SizedBox(height: 15),
                        _buildTextField(labelText: 'Celular', keyboardType: TextInputType.phone),
                        const SizedBox(height: 15),
                        _buildTextField(labelText: 'Email', keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 30),

                        // Botão Salvar
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Ação para salvar o cliente
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Dados do Cliente Salvos!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E73FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('salvar', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Botão de voltar flutuante (Bottom-Left)
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a página anterior
              },
              backgroundColor: const Color(0xFF1E73FF),
              foregroundColor: Colors.white,
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}