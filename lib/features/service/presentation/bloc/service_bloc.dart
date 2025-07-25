import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServiceInitial());

  @override
  Stream<ServiceState> mapEventToState(ServiceEvent event) async* {
    // TODO: Implementar lógica de serviços
  }
} 