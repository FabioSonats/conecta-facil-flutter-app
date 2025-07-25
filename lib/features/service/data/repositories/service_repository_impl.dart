import '../../domain/repositories/service_repository.dart';
import '../../domain/entities/service_entity.dart';
import '../datasources/service_remote_datasource.dart';
import '../models/service_model.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;
  ServiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ServiceEntity>> getServices({String? categoria, String? cidade, String? estado}) {
    return remoteDataSource.getServices(categoria: categoria, cidade: cidade, estado: estado);
  }

  @override
  Future<void> addService(ServiceEntity service) {
    return remoteDataSource.addService(service as ServiceModel);
  }

  @override
  Future<void> updateService(ServiceEntity service) {
    return remoteDataSource.updateService(service as ServiceModel);
  }

  @override
  Future<void> deleteService(String id) {
    return remoteDataSource.deleteService(id);
  }
} 