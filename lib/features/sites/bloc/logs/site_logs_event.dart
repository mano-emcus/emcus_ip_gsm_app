import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
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

class SiteLogsNewLogReceived extends SiteLogsEvent {
  SiteLogsNewLogReceived(this.newLog);
  final LogEntry newLog;

  @override
  List<Object?> get props => [newLog];
} 