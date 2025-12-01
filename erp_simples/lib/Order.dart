import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Definindo Enums baseados nos seus modelos Java/SQL

enum FormaPagamento { debito, credito, dinheiro, pix }

// --------------------------------------------------------------------------
// 1. MODELO DE ORDEM DE SERVIÇO
// --------------------------------------------------------------------------

class OrdemServico {
  final String idOS;
  final String servico;
  final String clienteId;
  final FormaPagamento formaPagamento;
  final bool statusPagamento;
  final DateTime dataEntrega;
  final String localEntrega;
  final String descricaoServico;

  OrdemServico({
    required this.idOS,
    required this.servico,
    required this.clienteId,
    required this.descricaoServico,
    required this.dataEntrega,
    required this.localEntrega,
    this.statusPagamento = false,
    this.formaPagamento = FormaPagamento.pix,
  });

  // Converte objeto para um Mapa (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'descricaoServico': descricaoServico,
      'dataEntrega': dataEntrega.toIso8601String(), // Salva como string ISO
      'localEntrega': localEntrega,
      'statusPagamento': statusPagamento,
      'formaPagamento': formaPagamento.name,
      'servico': servico,
    };
  }
}

// --------------------------------------------------------------------------
// 2. SERVIÇO DE ORDEM DE SERVIÇO (Backend)
// --------------------------------------------------------------------------

class OrdemServicoService {
  final CollectionReference _osCollection = FirebaseFirestore.instance
      .collection('ordensServico');

  // Adiciona uma nova Ordem de Serviço
  Future<void> addOS(OrdemServico os) async {
    await _osCollection.doc(os.idOS).set(os.toMap());
  }

  // Você pode adicionar getOSStream aqui para listar as OS futuramente
}
