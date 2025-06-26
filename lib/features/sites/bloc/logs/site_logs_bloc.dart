import 'package:emcus_ipgsm_app/core/services/socket_service.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_state.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_repository.dart';

class SiteLogsBloc extends Bloc<SiteLogsEvent, SiteLogsState> {
  SiteLogsBloc({SiteLogsRepository? siteLogsRepository})
      : _siteLogsRepository = siteLogsRepository ?? SiteLogsRepository(),
        super(SiteLogsInitial()) {
    on<SiteLogsFetched>(_onSiteLogsFetched);

    // Connect to socket and listen for new logs
    final socketService = SocketService();
    socketService.connect('https://ipgsm.emcus.co.in');
    socketService.onNewLog((data) {
      try {
        final newLog = LogEntry.fromJson(data);
        add(SiteLogsNewLogReceived(newLog));
      } catch (e) {
        throw Exception('Failed to parse new log: $e');
      }
    });
  }
  final SiteLogsRepository _siteLogsRepository;

  Future<void> _onSiteLogsFetched(
    SiteLogsFetched event,
    Emitter<SiteLogsState> emit,
  ) async {
    emit(SiteLogsLoading());
    try {
      final response = await _siteLogsRepository.fetchSiteLogs(siteId: event.siteId);
      if (response.statusCode == 1) {
        emit(SiteLogsSuccess(logs: response.data, message: response.message));
      } else {
        emit(SiteLogsFailure(error: response.message));
      }
    } catch (e) {
      emit(SiteLogsFailure(error: e.toString()));
    }
  }
}
