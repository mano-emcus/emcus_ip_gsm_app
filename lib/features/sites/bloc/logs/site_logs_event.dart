import 'package:equatable/equatable.dart';

abstract class SiteLogsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteLogsFetched extends SiteLogsEvent {
  SiteLogsFetched({required this.siteId});
  final int siteId;

  @override
  List<Object?> get props => [siteId];
}
