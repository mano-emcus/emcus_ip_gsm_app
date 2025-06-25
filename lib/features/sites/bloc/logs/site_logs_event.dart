import 'package:equatable/equatable.dart';

abstract class SiteLogsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteLogsFetched extends SiteLogsEvent {
  final int siteId;
  SiteLogsFetched({required this.siteId});

  @override
  List<Object?> get props => [siteId];
}
