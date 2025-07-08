import 'dart:async';

import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_repository.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_state.dart';
import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SitesBloc extends Bloc<SitesEvent, SitesState> {
  SitesBloc({required SitesRepository sitesRepository})
    : _sitesRepository = sitesRepository,
      super(SitesInitial()) {
    on<SitesFetched>(_onSitesFetched);
    on<SitesFilterChanged>(_onSitesFilterChanged);
  }

  final SitesRepository _sitesRepository;
  List<SiteData> _allSites = [];

  Future<void> _onSitesFetched(
    SitesFetched event,
    Emitter<SitesState> emit,
  ) async {
    emit(SitesLoading());
    try {
      final response = await _sitesRepository.fetchSites();
      _allSites = response.data;
      if (response.statusCode == 1) {
        emit(SitesSuccess(sites: _allSites));
      } else {
        emit(SitesFailure(error: response.message));
      }
    } catch (e) {
      emit(SitesFailure(error: e.toString()));
    }
  }

  Future<void> _onSitesFilterChanged(
    SitesFilterChanged event,
    Emitter<SitesState> emit,
  ) async {
    final filtered =
        _allSites
            .where(
              (site) => site.siteName.toLowerCase().contains(
                event.filter.toLowerCase(),
              ) || site.siteLocation.toLowerCase().contains(
                event.filter.toLowerCase(),
              ) || site.company.toLowerCase().contains(
                event.filter.toLowerCase(),
              ),
            )
            .toList();
    emit(SitesSuccess(sites: filtered));
  }

  @override
  Future<void> close() {
    _sitesRepository.dispose();
    return super.close();
  }
}
