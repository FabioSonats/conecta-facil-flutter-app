import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/service/data/datasources/service_remote_datasource.dart';
import '../../features/service/data/datasources/service_remote_datasource_impl.dart';
import '../../features/service/data/repositories/service_repository_impl.dart';
import '../../features/service/domain/repositories/service_repository.dart';

final sl = GetIt.instance;

void setupInjector() {
  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(sl()));
}
