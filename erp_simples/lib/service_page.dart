import 'package:flutter/material.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  bool _isPaid = false; // Estado para o checkbox "Está pago?"

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
        // O título "Serviços - menu" pode ser adicionado acima do Scaffold
        // ou você pode mudar o title da AppBar se preferir.
      ),
      body: Stack( // Usamos Stack para o botão de voltar flutuante
        children: [
          SingleChildScrollView( // Permite scroll se o conteúdo for grande
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    "Serviços - menu", // Título acima da área do formulário
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
                      boxShadow: [ // Opcional: para dar um leve efeito de profundidade
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(labelText: 'Serviço'),
                        const SizedBox(height: 15),
                        _buildTextField(labelText: 'Cliente'),
                        const SizedBox(height: 15),
                        _buildTextField(labelText: 'Forma de pagamento'),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Checkbox(
                              value: _isPaid,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isPaid = newValue ?? false;
                                });
                              },
                              activeColor: Colors.blue, // Cor do checkbox quando marcado
                            ),
                            const Text('Está pago?'),
                          ],
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(labelText: 'Data de entrega', keyboardType: TextInputType.datetime),
                        const SizedBox(height: 15),
                        _buildTextField(labelText: 'Local de entrega'),
                        const SizedBox(height: 15),

                        const Text('Descrição adicional:', style: TextStyle(fontSize: 16, color: Colors.black54)),
                        const SizedBox(height: 5),
                        _buildTextField(labelText: '', maxLines: 4, hintText: 'Detalhes adicionais do serviço'),
                        const SizedBox(height: 30),

                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Ação para salvar o serviço
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Serviço Salvo!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E73FF), // Cor do botão "salvar"
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
                // Adiciona um espaçamento inferior para o botão flutuante não cobrir o conteúdo
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

  Widget _buildTextField({
    required String labelText,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding interno
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}