import 'package:equatable/equatable.dart';

abstract class SitesEvent extends Equatable {
  const SitesEvent();

  @override
  List<Object> get props => [];
}

class SitesFetched extends SitesEvent {
  const SitesFetched();

  @override
  List<Object> get props => [];
}

class SitesFilterChanged extends SitesEvent {
  SitesFilterChanged({required this.filter});
  final String filter;

  @override
  List<Object> get props => [filter];
}