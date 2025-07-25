import '../repositories/service_repository.dart';
import '../entities/service_entity.dart';

class AddServiceUseCase {
  final ServiceRepository repository;
  AddServiceUseCase(this.repository);

  Future<void> call(ServiceEntity service) {
    return repository.addService(service);
  }
} 