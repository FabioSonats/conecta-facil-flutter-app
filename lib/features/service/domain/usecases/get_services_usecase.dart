import '../repositories/service_repository.dart';
import '../entities/service_entity.dart';

class GetServicesUseCase {
  final ServiceRepository repository;
  GetServicesUseCase(this.repository);

  Future<List<ServiceEntity>> call({String? categoria, String? cidade, String? estado}) {
    return repository.getServices(categoria: categoria, cidade: cidade, estado: estado);
  }
} 