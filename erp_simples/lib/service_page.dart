import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'Order.dart'; // Modelo de Ordem de Serviço
import 'Cliente.dart'; // Modelo de Cliente (para buscar a lista)

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final OrdemServicoService _osService = OrdemServicoService();
  final ClienteService _clienteService =
      ClienteService(); // Serviço para buscar clientes
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController _servicoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  // Variáveis de Estado
  bool _isPaid = false;
  FormaPagamento _formaSelecionada = FormaPagamento.pix;
  String?
  _selectedClienteId; // Armazena o ID do cliente selecionado no Dropdown

  // Selecionar Data
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final dataFinal =
          DateTime.tryParse(_dataController.text) ?? DateTime.now();

      final novaOS = OrdemServico(
        id: const Uuid().v4(),
        clienteId: _selectedClienteId!, // Usa o ID selecionado no Dropdown
        servico: _servicoController.text,
        descricaoServico: _descricaoController.text,
        localEntrega: _localController.text,
        dataEntrega: dataFinal,
        statusPagamento: _isPaid,
        formaPagamento: _formaSelecionada.name,
      );

      try {
        await _osService.addOS(novaOS);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Serviço Salvo!')));
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint('Erro: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      appBar: AppBar(
        title: const Text(
          "Novo Serviço",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E73FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _servicoController,
                    decoration: const InputDecoration(
                      labelText: "Título do Serviço",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 10),

                  // --- DROPDOWN DE CLIENTES ---
                  StreamBuilder<List<Cliente>>(
                    stream: _clienteService.getClientesStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator(); // Carregando...
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'Erro ao carregar clientes: ${snapshot.error}',
                        );
                      }

                      final clientes = snapshot.data ?? [];

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Selecione o Cliente",
                        ),
                        value: _selectedClienteId,
                        items: clientes.map((cliente) {
                          return DropdownMenuItem(
                            value: cliente.id, // O valor será o ID
                            child: Text(
                              cliente.nomeCliente,
                            ), // O texto será o Nome
                          );
                        }).toList(),
                        onChanged: (valor) {
                          setState(() {
                            _selectedClienteId = valor;
                          });
                        },
                        validator: (v) =>
                            v == null ? 'Selecione um cliente' : null,
                      );
                    },
                  ),

                  // ----------------------------
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _valorController,
                    decoration: const InputDecoration(labelText: "Valor (R\$)"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(
                      labelText: "Descrição Detalhada",
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _localController,
                    decoration: const InputDecoration(
                      labelText: "Local de Entrega",
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Campo de Data
                  TextFormField(
                    controller: _dataController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Data de Entrega",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _selectDate,
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Selecione uma data' : null,
                  ),
                  const SizedBox(height: 10),

                  // Dropdown Pagamento
                  DropdownButtonFormField<FormaPagamento>(
                    value: _formaSelecionada,
                    decoration: const InputDecoration(
                      labelText: "Forma de Pagamento",
                    ),
                    items: FormaPagamento.values.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(f.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _formaSelecionada = v!),
                  ),

                  // Checkbox Pago
                  Row(
                    children: [
                      Checkbox(
                        value: _isPaid,
                        onChanged: (v) => setState(() => _isPaid = v!),
                      ),
                      const Text("Já está pago?"),
                    ],
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E73FF),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Salvar Serviço"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
