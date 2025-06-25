import 'package:equatable/equatable.dart';

abstract class SiteDevicesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteDevicesInitial extends SiteDevicesState {}

class SiteDevicesLoading extends SiteDevicesState {}

class SiteDevicesSuccess extends SiteDevicesState {
  SiteDevicesSuccess({required this.devices, required this.message});
  final List<dynamic> devices;
  final String message;

  @override
  List<Object?> get props => [devices, message];
}

class SiteDevicesFailure extends SiteDevicesState {
  SiteDevicesFailure({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}
