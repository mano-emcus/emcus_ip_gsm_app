import 'package:equatable/equatable.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';

abstract class LogsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogsFetched extends LogsEvent {
  LogsFetched();
  
  @override
  List<Object?> get props => [];
}

class LogsRefresh extends LogsEvent {
  LogsRefresh();
  
  @override
  List<Object?> get props => [];
}

class LogsNewLogReceived extends LogsEvent {
  LogsNewLogReceived(this.newLog);
  final LogEntry newLog;

  @override
  List<Object?> get props => [newLog];
} 