import 'package:equatable/equatable.dart';

abstract class SiteDevicesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteDevicesFetched extends SiteDevicesEvent {
  final int siteId;
  SiteDevicesFetched({required this.siteId});

  @override
  List<Object?> get props => [siteId];
}
