import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Definindo Enums
enum FormaPagamento { debito, credito, dinheiro, pix }

class OrdemServico {
  final String id; // ID do documento no Firestore
  final String clienteId;
  final String servico; // Título curto do serviço
  final String descricaoServico; // Detalhes
  final String localEntrega;
  final DateTime dataEntrega;
  final bool statusPagamento;
  final String formaPagamento; // Vamos salvar como String (nome do enum)

  OrdemServico({
    required this.id,
    required this.clienteId,
    required this.servico,
    required this.descricaoServico,
    required this.localEntrega,
    required this.dataEntrega,
    required this.statusPagamento,
    required this.formaPagamento,
  });

  // Converter para Mapa (Salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'servico': servico,
      'descricaoServico': descricaoServico,
      'localEntrega': localEntrega,
      'dataEntrega': dataEntrega
          .toIso8601String(), // Salva data como String ISO
      'statusPagamento': statusPagamento,
      'formaPagamento': formaPagamento,
    };
  }

  // Criar objeto a partir do Firestore (Ler do Firestore)
  factory OrdemServico.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return OrdemServico(
      id: doc.id,
      clienteId: data['clienteId'] ?? '',
      servico: data['servico'] ?? '',
      descricaoServico: data['descricaoServico'] ?? '',
      localEntrega: data['localEntrega'] ?? '',
      // Converte a string ISO de volta para DateTime, ou usa data atual se der erro
      dataEntrega:
          DateTime.tryParse(data['dataEntrega'] ?? '') ?? DateTime.now(),
      statusPagamento: data['statusPagamento'] ?? false,
      formaPagamento: data['formaPagamento'] ?? 'pix',
    );
  }
}

// Serviço para salvar no banco
class OrdemServicoService {
  final CollectionReference _osCollection = FirebaseFirestore.instance
      .collection('ordensServico');

  Future<void> addOS(OrdemServico os) async {
    // Salva o documento usando o ID gerado (os.id)
    await _osCollection.doc(os.id).set(os.toMap());
  }
}
