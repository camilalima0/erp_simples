import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'Delivery.dart'; // Modelo e Serviço de Entrega
import 'Cliente.dart'; // Modelo e Serviço de Cliente (para o Dropdown)

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  // Serviços
  final EntregaService _entregaService = EntregaService();
  final ClienteService _clienteService = ClienteService();

  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController _produtoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Variável para armazenar o ID do cliente selecionado no Dropdown
  String? _selectedClienteId;

  // Função para abrir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Salva formato ISO (YYYY-MM-DD) para facilitar conversão depois
        _dateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  // Função para Salvar a Entrega
  void _saveEntrega() async {
    if (_formKey.currentState!.validate()) {
      // Converte o texto da data ou usa a data atual se falhar
      final dataFinal =
          DateTime.tryParse(_dateController.text) ?? DateTime.now();

      final novaEntrega = Entrega(
        id: const Uuid().v4(), // Gera ID único
        clienteId: _selectedClienteId!, // ID vindo do Dropdown
        produto: _produtoController.text,
        descricaoAdicional: _descricaoController.text,
        localEntrega: _localController.text,
        dataEntrega: dataFinal,
      );

      try {
        await _entregaService.addEntrega(novaEntrega);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entrega Agendada com Sucesso!')),
          );
          Navigator.pop(context); // Volta para o menu
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao agendar: $e')));
        }
      }
    }
  }

  // Função auxiliar para criar campos de texto simples
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText :',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          maxLines: maxLines,
          validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                "Agenda de Entregas",
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),

            Center(
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20, top: 10),
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
                      const Text(
                        'Cliente :',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 5),

                      // --- DROPDOWN DE CLIENTES (STREAM BUILDER) ---
                      StreamBuilder<List<Cliente>>(
                        stream: _clienteService.getClientesStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Erro ao carregar clientes');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }

                          final listaClientes = snapshot.data ?? [];

                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            value: _selectedClienteId,
                            isExpanded:
                                true, // Evita estouro de layout se o nome for grande
                            hint: const Text("Selecione um cliente"),
                            items: listaClientes.map((cliente) {
                              return DropdownMenuItem(
                                value: cliente.id,
                                child: Text(
                                  cliente.nomeCliente,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (v) =>
                                setState(() => _selectedClienteId = v),
                            validator: (v) =>
                                v == null ? 'Selecione um cliente' : null,
                          );
                        },
                      ),

                      // ---------------------------------------------
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _produtoController,
                        labelText: 'Produto da entrega',
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _descricaoController,
                        labelText: 'Descrição adicional',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _localController,
                        labelText: 'Local da entrega',
                      ),
                      const SizedBox(height: 15),

                      // Campo de Data
                      Row(
                        children: [
                          const Text(
                            'Data :',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Selecione uma data'
                                  : null,
                              decoration: InputDecoration(
                                hintText: 'AAAA-MM-DD',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: _saveEntrega,
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
                          'Salvar Entrega',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
