import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_event.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_state.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_repository.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc({LogsRepository? logsRepository})
    : _logsRepository = logsRepository ?? LogsRepository(),
      super(LogsInitial()) {
    on<LogsFetched>(_onLogsFetched);
  }
  final LogsRepository _logsRepository;

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
}
