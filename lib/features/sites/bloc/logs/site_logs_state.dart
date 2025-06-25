import 'package:equatable/equatable.dart';
import 'package:emcus_ipgsm_app/features/sites/models/site_logs_response.dart';

abstract class SiteLogsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteLogsInitial extends SiteLogsState {}

class SiteLogsLoading extends SiteLogsState {}

class SiteLogsSuccess extends SiteLogsState {
  SiteLogsSuccess({required this.logs, required this.message});
  final List<SiteLogsData> logs;
  final String message;

  @override
  List<Object?> get props => [logs, message];
}

class SiteLogsFailure extends SiteLogsState {
  SiteLogsFailure({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}
