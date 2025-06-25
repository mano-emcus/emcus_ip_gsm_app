import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_state.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_repository.dart';

class SiteLogsBloc extends Bloc<SiteLogsEvent, SiteLogsState> {
  SiteLogsBloc({SiteLogsRepository? siteLogsRepository})
      : _siteLogsRepository = siteLogsRepository ?? SiteLogsRepository(),
        super(SiteLogsInitial()) {
    on<SiteLogsFetched>(_onSiteLogsFetched);
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
