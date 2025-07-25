import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';
import 'service_remote_datasource.dart';

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ServiceModel>> getServices({String? categoria, String? cidade, String? estado}) async {
    Query query = _firestore.collection('services');
    if (categoria != null) query = query.where('categoria', isEqualTo: categoria);
    if (cidade != null) query = query.where('cidade', isEqualTo: cidade);
    if (estado != null) query = query.where('estado', isEqualTo: estado);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => ServiceModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> addService(ServiceModel service) async {
    await _firestore.collection('services').doc(service.id).set(service.toMap());
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    await _firestore.collection('services').doc(service.id).update(service.toMap());
  }

  @override
  Future<void> deleteService(String id) async {
    await _firestore.collection('services').doc(id).delete();
  }
} 