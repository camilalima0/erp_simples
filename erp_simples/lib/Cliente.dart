import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// --------------------------------------------------------------------------
// 1. MODELO DE DADOS (Substitui as Entidades JPA)
// --------------------------------------------------------------------------

class Cliente {
  final String id;
  final String nomeCliente;
  final String documentoCliente;
  final String emailCliente;

  Cliente({
    required this.id,
    required this.nomeCliente,
    required this.documentoCliente,
    required this.emailCliente,
  });

  // Converte DocumentSnapshot do Firestore para o objeto Cliente
  factory Cliente.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Cliente(
      id: doc.id,
      nomeCliente: data['nomeCliente'] ?? 'Sem Nome',
      documentoCliente: data['documentoCliente'] ?? 'N/A',
      emailCliente: data['emailCliente'] ?? 'N/A',
    );
  }

  // Converte objeto Cliente para um Mapa para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'nomeCliente': nomeCliente,
      'documentoCliente': documentoCliente,
      'emailCliente': emailCliente,
    };
  }
}

// --------------------------------------------------------------------------
// 2. SERVIÇO DE DADOS (Substitui o ClienteService e ClienteRepository)
// --------------------------------------------------------------------------

class ClienteService {
  final CollectionReference _clientesCollection = FirebaseFirestore.instance
      .collection('clientes');

  // Adiciona um novo cliente (Substitui postCliente)
  Future<void> addCliente(Cliente cliente) async {
    // Usamos o ID gerado pelo UUID como ID do documento Firestore
    await _clientesCollection.doc(cliente.id).set(cliente.toMap());
  }

  // Deleta um cliente (Substitui deleteCliente)
  Future<void> deleteCliente(String id) async {
    await _clientesCollection.doc(id).delete();
  }

  // Lista todos os clientes em tempo real (Substitui listarClientes com onSnapshot)
  Stream<List<Cliente>> getClientesStream() {
    // O .snapshots() retorna uma Stream, mantendo a lista de clientes atualizada
    return _clientesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Cliente.fromFirestore(doc)).toList();
    });
  }
}
