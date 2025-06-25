import 'package:equatable/equatable.dart';
import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';

abstract class SitesState extends Equatable {
  const SitesState();

  @override
  List<Object> get props => [];
}

class SitesInitial extends SitesState {}

class SitesLoading extends SitesState {}

class SitesSuccess extends SitesState {
  const SitesSuccess({required this.sites});
  final List<SiteData> sites;

  @override
  List<Object> get props => [sites];
}

class SitesFailure extends SitesState {
  const SitesFailure({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}