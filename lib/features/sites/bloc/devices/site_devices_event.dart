import 'package:equatable/equatable.dart';

abstract class SiteDevicesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteDevicesFetched extends SiteDevicesEvent {
  SiteDevicesFetched({required this.siteId});
  final int siteId;

  @override
  List<Object?> get props => [siteId];
}
