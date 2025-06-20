import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_repository.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc({LogsRepository? logsRepository})
    : _logsRepository = logsRepository ?? LogsRepository(),
      super(LogsInitial()) {
    on<LogsFetched>(_onLogsFetched);
    on<LogsPollingStarted>(_onLogsPollingStarted);
    on<LogsPollingStop>(_onLogsPollingStop);
    on<LogsRefresh>(_onLogsRefresh);
  }
  final LogsRepository _logsRepository;
  Timer? _pollingTimer;

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
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

  Future<void> _onLogsPollingStarted(
    LogsPollingStarted event,
    Emitter<LogsState> emit,
  ) async {
    // Cancel any existing timer
    _pollingTimer?.cancel();
    
    // Fetch logs immediately
    add(LogsFetched());
    
    // Start periodic polling
    _pollingTimer = Timer.periodic(event.interval, (timer) {
      if (!isClosed) {
        add(LogsRefresh());
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _onLogsPollingStop(
    LogsPollingStop event,
    Emitter<LogsState> emit,
  ) async {
    _pollingTimer?.cancel();
    _pollingTimer = null;
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
}
