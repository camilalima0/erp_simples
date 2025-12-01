import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'Order.dart'; // Importa o novo modelo e serviço de OS

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final OrdemServicoService _osService = OrdemServicoService();
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController _servicoController = TextEditingController();
  final TextEditingController _clienteIdController =
      TextEditingController(); // Temporário para Cliente ID
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _dataEntregaController = TextEditingController();
  final TextEditingController _localEntregaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  // Estados dos Enums
  bool _isPaid = false;
  FormaPagamento _formaPagamento = FormaPagamento.pix;

  // Função para abrir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        _dataEntregaController.text = formattedDate;
      });
    }
  }

  // Função para salvar no Firestore
  void _saveOS() async {
    if (_formKey.currentState!.validate()) {
      // Converte a data string de volta para DateTime (necessário para o modelo)
      final parts = _dataEntregaController.text.split('/');
      final dataEntrega = DateTime(
        int.parse(parts[2]), // Ano
        int.parse(parts[1]), // Mês
        int.parse(parts[0]), // Dia
      );

      final newOS = OrdemServico(
        idOS: const Uuid().v4(),
        clienteId: _clienteIdController
            .text, // **NOTA: ID do Cliente é inserido como texto aqui**
        descricaoServico: _servicoController.text,
        servico: _servicoController.text,
        dataEntrega: dataEntrega,
        localEntrega: _localEntregaController.text,
        statusPagamento: _isPaid,
        formaPagamento: _formaPagamento,
      );

      try {
        await _osService.addOS(newOS);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ordem de Serviço salva no Firestore!'),
            ),
          );
          // Limpar ou voltar
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao salvar OS: $e')));
        }
      }
    }
  }

  // Função auxiliar para construir os campos de texto
  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _servicoController.dispose();
    _clienteIdController.dispose();
    _valorController.dispose();
    _dataEntregaController.dispose();
    _localEntregaController.dispose();
    _descricaoController.dispose();
    super.dispose();
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
                    "Serviços - menu",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 320,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            labelText: 'Descrição do Serviço',
                            controller: _servicoController,
                          ),
                          const SizedBox(height: 15),

                          // NOTA: IDEALMENTE SERIA UM DROPDOWN COM CLIENTES REAIS
                          _buildTextField(
                            labelText: 'ID do Cliente (Temporário)',
                            controller: _clienteIdController,
                          ),
                          const SizedBox(height: 15),

                          _buildTextField(
                            labelText: 'Valor do Serviço',
                            controller: _valorController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 15),

                          // Dropdown para Forma de Pagamento
                          const Text(
                            'Forma de pagamento:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          DropdownButtonFormField<FormaPagamento>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            value: _formaPagamento,
                            items: FormaPagamento.values.map((fp) {
                              return DropdownMenuItem(
                                value: fp,
                                child: Text(fp.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (FormaPagamento? newValue) {
                              setState(() {
                                _formaPagamento = newValue!;
                              });
                            },
                          ),
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
                                activeColor: Colors.blue,
                              ),
                              const Text('Está pago?'),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Campo de Data com Seletor
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  labelText: 'Data de entrega (dd/mm/aaaa)',
                                  controller: _dataEntregaController,
                                  readOnly: true,
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.red,
                                ),
                                onPressed: () => _selectDate(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          _buildTextField(
                            labelText: 'Local de entrega',
                            controller: _localEntregaController,
                          ),
                          const SizedBox(height: 15),

                          // Campo Descrição Adicional
                          const Text(
                            'Descrição adicional (Detalhes):',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildTextField(
                            labelText: '',
                            controller: _descricaoController,
                            maxLines: 4,
                            hintText: 'Detalhes adicionais do serviço',
                          ),
                          const SizedBox(height: 30),

                          Center(
                            child: ElevatedButton(
                              onPressed:
                                  _saveOS, // Chama a função de salvar no Firestore
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
