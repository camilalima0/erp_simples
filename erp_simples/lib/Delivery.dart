import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Entrega {
  final String id;
  final String clienteId;
  final String produto;
  final String descricaoAdicional;
  final String localEntrega;
  final DateTime dataEntrega;

  Entrega({
    required this.id,
    required this.clienteId,
    required this.produto,
    required this.descricaoAdicional,
    required this.localEntrega,
    required this.dataEntrega,
  });

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'produto': produto,
      'descricaoAdicional': descricaoAdicional,
      'localEntrega': localEntrega,
      'dataEntrega': dataEntrega.toIso8601String(),
    };
  }

  factory Entrega.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Entrega(
      id: doc.id,
      clienteId: data['clienteId'] ?? '',
      produto: data['produto'] ?? '',
      descricaoAdicional: data['descricaoAdicional'] ?? '',
      localEntrega: data['localEntrega'] ?? '',
      dataEntrega:
          DateTime.tryParse(data['dataEntrega'] ?? '') ?? DateTime.now(),
    );
  }
}

class EntregaService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'entregas',
  );

  Future<void> addEntrega(Entrega entrega) async {
    await _collection.doc(entrega.id).set(entrega.toMap());
  }
}
