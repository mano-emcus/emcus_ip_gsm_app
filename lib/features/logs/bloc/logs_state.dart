import 'package:equatable/equatable.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';

abstract class LogsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogsInitial extends LogsState {}

class LogsLoading extends LogsState {}

class LogsSuccess extends LogsState {
  final List<LogEntry> logs;
  final String message;

  LogsSuccess({
    required this.logs,
    required this.message,
  });

  @override
  List<Object?> get props => [logs, message];
}

class LogsFailure extends LogsState {
  final String error;

  LogsFailure({required this.error});

  @override
  List<Object?> get props => [error];
} 