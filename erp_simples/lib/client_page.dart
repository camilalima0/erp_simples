import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'Cliente.dart'; // Importa o modelo e o serviço

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  // Inicializa o serviço Firestore
  final ClienteService _clienteService = ClienteService();
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para os campos do formulário
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // Precisamos adicionar o campo 'documentoCliente' que está no seu modelo de dados
  final TextEditingController _documentoController = TextEditingController();

  // Função para salvar o cliente no Firestore
  void _saveCliente() async {
    if (_formKey.currentState!.validate()) {
      final newCliente = Cliente(
        // O ID único é gerado aqui
        id: const Uuid().v4(),
        nomeCliente: _nomeController.text,
        documentoCliente: _documentoController.text,
        emailCliente: _emailController.text,
        // O modelo original tinha 'telefoneCliente', usaremos 'celular' para preencher
        // Em um app real, você precisaria de um campo para 'telefone' e 'celular'.
      );

      try {
        await _clienteService.addCliente(newCliente);

        // Exibe feedback de sucesso e limpa os campos
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cliente salvo com sucesso no Firestore!'),
            ),
          );
          // Limpa os campos após salvar
          _nomeController.clear();
          _celularController.clear();
          _emailController.clear();
          _documentoController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao salvar cliente: $e')));
        }
      }
    }
  }

  // --- Funções Auxiliares de UI ---
  // Função auxiliar para construir os campos de texto com validação
  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      // Usando TextFormField para validação
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _celularController.dispose();
    _emailController.dispose();
    _documentoController.dispose();
    super.dispose();
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
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    "Cliente - menu", // Título acima da área do formulário
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Círculo para a imagem/avatar (ícone de perfil)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(
                                  0xFFD9D9D9,
                                ), // Cor cinza clara do círculo
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),

                          // Campos de Texto
                          _buildTextField(
                            labelText: 'Nome completo',
                            controller: _nomeController,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            labelText: 'Documento (CPF/CNPJ)',
                            controller: _documentoController,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            labelText: 'Celular',
                            controller: _celularController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            labelText: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 30),

                          // Botão Salvar
                          Center(
                            child: ElevatedButton(
                              onPressed:
                                  _saveCliente, // Chama a função de salvar
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E73FF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'salvar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
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
