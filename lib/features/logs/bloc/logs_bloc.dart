import 'dart:async';
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_repository.dart';
import 'package:emcus_ipgsm_app/core/services/socket_service.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc({LogsRepository? logsRepository})
    : _logsRepository = logsRepository ?? LogsRepository(),
      super(LogsInitial()) {
    on<LogsFetched>(_onLogsFetched);
    on<LogsRefresh>(_onLogsRefresh);
    on<LogsNewLogReceived>(_onNewLogReceived);

    // Connect to socket and listen for new logs
    final socketService = SocketService();
    socketService.connect('https://ipgsm.emcus.co.in');
    socketService.onNewLog((data) {
      try {
        final newLog = LogEntry.fromJson(data);
        add(LogsNewLogReceived(newLog));
      } catch (e) {
        print('Failed to parse new log: $e');
      }
    });
  }
  final LogsRepository _logsRepository;

  @override
  Future<void> close() {
    // SocketService().disconnect();
    return super.close();
  }

  Future<void> _onLogsFetched(
    LogsFetched event,
    Emitter<LogsState> emit,
  ) async {
    emit(LogsLoading());
    try {
      final response = await _logsRepository.fetchLogs();

      if (response.statusCode == 1) {
        emit(LogsSuccess(logs: response.data, message: response.message));
      } else {
        emit(LogsFailure(error: response.message));
      }
    } catch (e) {
      emit(LogsFailure(error: e.toString()));
    }
  }

  Future<void> _onLogsRefresh(
    LogsRefresh event,
    Emitter<LogsState> emit,
  ) async {
    // Refresh logs without showing loading state to avoid UI flickering
    try {
      final response = await _logsRepository.fetchLogs();

      if (response.statusCode == 1) {
        emit(LogsSuccess(logs: response.data, message: response.message));
      } else {
        emit(LogsFailure(error: response.message));
      }
    } catch (e) {
      emit(LogsFailure(error: e.toString()));
    }
  }

  Future<void> _onNewLogReceived(
    LogsNewLogReceived event,
    Emitter<LogsState> emit,
  ) async {
    if (state is LogsSuccess) {
      final currentLogs = List<LogEntry>.from((state as LogsSuccess).logs);
      currentLogs.insert(0, event.newLog);
      emit(LogsSuccess(logs: currentLogs, message: 'New log received'));
    }
  }
}
