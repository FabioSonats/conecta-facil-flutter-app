part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadServices extends ServiceEvent {
  final String? categoria;
  final String? cidade;
  final String? estado;
  const LoadServices({this.categoria, this.cidade, this.estado});

  @override
  List<Object?> get props => [categoria, cidade, estado];
} 