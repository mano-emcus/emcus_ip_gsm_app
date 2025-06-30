import 'dart:async';

import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_repository.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SitesBloc extends Bloc<SitesEvent, SitesState> {
  SitesBloc({required SitesRepository sitesRepository})
      : _sitesRepository = sitesRepository,
        super(SitesInitial()) {
    on<SitesFetched>(_onSitesFetched);
  }
  
  final SitesRepository _sitesRepository;

  Future<void> _onSitesFetched(
    SitesFetched event,
    Emitter<SitesState> emit,
  ) async {
    emit(SitesLoading());
    try {
      final response = await _sitesRepository.fetchSites();

      if (response.statusCode == 1) {
        emit(SitesSuccess(sites: response.data));
      } else {
        emit(SitesFailure(error: response.message));
      }
    } catch (e) {
      emit(SitesFailure(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sitesRepository.dispose();
    return super.close();
  }
}