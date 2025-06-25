import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_state.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_repository.dart';

class SiteDevicesBloc extends Bloc<SiteDevicesEvent, SiteDevicesState> {
  SiteDevicesBloc({SiteDevicesRepository? siteDevicesRepository})
      : _siteDevicesRepository = siteDevicesRepository ?? SiteDevicesRepository(),
        super(SiteDevicesInitial()) {
    on<SiteDevicesFetched>(_onSiteDevicesFetched);
  }
  final SiteDevicesRepository _siteDevicesRepository;

  Future<void> _onSiteDevicesFetched(
    SiteDevicesFetched event,
    Emitter<SiteDevicesState> emit,
  ) async {
    emit(SiteDevicesLoading());
    try {
      final response = await _siteDevicesRepository.fetchSiteDevices(siteId: event.siteId);
      if (response.statusCode == 1) {
        emit(SiteDevicesSuccess(devices: response.data, message: response.message));
      } else {
        emit(SiteDevicesFailure(error: response.message));
      }
    } catch (e) {
      emit(SiteDevicesFailure(error: e.toString()));
    }
  }
}
