import 'package:emcus_ipgsm_app/core/services/socket_service.dart';
import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';
import 'package:emcus_ipgsm_app/features/sites/models/site_logs_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_state.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_repository.dart';

class SiteLogsBloc extends Bloc<SiteLogsEvent, SiteLogsState> {
  SiteLogsBloc({required SiteLogsRepository siteLogsRepository})
    : _siteLogsRepository = siteLogsRepository,
      super(SiteLogsInitial()) {
    on<SiteLogsFetched>(_onSiteLogsFetched);
    on<SiteLogsNewLogReceived>(_onSiteLogsNewLogReceived);

    // Connect to socket and listen for new logs
    // socketService.connect('https://ipgsm.emcus.co.in/websocket/site-logs');
    // socketService.onNewLog((data) {
    //   try {
    //     final newLog = LogEntry.fromJson(data);
    //     add(SiteLogsNewLogReceived(newLog));
    //   } catch (e) {
    //     throw Exception('Failed to parse new log: $e');
    //   }
    // });
  }
  final SiteLogsRepository _siteLogsRepository;

  Future<void> _onSiteLogsFetched(
    SiteLogsFetched event,
    Emitter<SiteLogsState> emit,
  ) async {
    emit(SiteLogsLoading());
    try {
      final response = await _siteLogsRepository.fetchSiteLogs(
        siteId: event.siteId,
      );
      if (response.statusCode == 1) {
        emit(SiteLogsSuccess(logs: response.data, message: response.message));
      } else {
        emit(SiteLogsFailure(error: response.message));
      }
    } catch (e) {
      emit(SiteLogsFailure(error: e.toString()));
    }
  }

  void _onSiteLogsNewLogReceived(
    SiteLogsNewLogReceived event,
    Emitter<SiteLogsState> emit,
  ) {
    if (state is SiteLogsSuccess) {
      final currentState = state as SiteLogsSuccess;
      if (currentState.logs.allCount == 0) {
        final currentData = currentState.logs;
        final log = event.newLog;
        final isFire = log.u16EventId >= 1001 && log.u16EventId <= 1007;
        final isFault = log.u16EventId >= 2000 && log.u16EventId < 3000;
        final newFire = List<LogEntry>.from(currentData.fire);
        final newFault = List<LogEntry>.from(currentData.fault);
        final newAll = List<LogEntry>.from(currentData.all);
        newAll.insert(0, log);
        if (isFire) newFire.insert(0, log);
        if (isFault) newFault.insert(0, log);
        final updatedData = SiteLogsData(
          fireCount: isFire ? currentData.fireCount + 1 : currentData.fireCount,
          faultCount:
              isFault ? currentData.faultCount + 1 : currentData.faultCount,
          allCount: currentData.allCount + 1,
          fire: newFire,
          fault: newFault,
          all: newAll,
        );
        emit(SiteLogsSuccess(logs: updatedData, message: currentState.message));
      }
    }
  }
}
