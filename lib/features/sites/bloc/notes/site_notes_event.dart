import 'package:equatable/equatable.dart';

abstract class SiteNotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteNotesFetched extends SiteNotesEvent {
  SiteNotesFetched({required this.siteId});
  final int siteId;

  @override
  List<Object?> get props => [siteId];
}
