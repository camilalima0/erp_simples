import 'package:flutter/material.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  // Controlador para o campo de data
  final TextEditingController _dateController = TextEditingController();

  // Função para abrir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // Formata a data para o formato dd/MM/yyyy
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  // Função auxiliar para construir os campos de texto
  Widget _buildTextField({
    required String labelText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText :',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                "agenda menu",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),

            // Botão/Título "Agendar nova entrega"
            Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.symmetric(vertical: 20),
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E73FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "Agendar nova entrega",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Card Branco do Formulário
            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
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
                    _buildTextField(labelText: 'Cliente'),
                    const SizedBox(height: 15),
                    _buildTextField(labelText: 'Produto da entrega'),
                    const SizedBox(height: 15),

                    // Campo Descrição Adicional (Multilinha)
                    _buildTextField(
                      labelText: 'Descrição adicional',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(labelText: 'Local da entrega'),
                    const SizedBox(height: 15),

                    // Campo de Data com Seletor
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'data :',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _dateController,
                            readOnly:
                                true, // Impede que o usuário digite a data
                            decoration: InputDecoration(
                              hintText: '00/00/0000',
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.red,
                                ), // Ícone de calendário vermelho
                                onPressed: () => _selectDate(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Botão Salvar
                    ElevatedButton(
                      onPressed: () {
                        // Ação para salvar a entrega
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Entrega Agendada!')),
                        );
                      },
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
