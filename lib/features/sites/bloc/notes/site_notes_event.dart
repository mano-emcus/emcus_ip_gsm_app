import 'package:equatable/equatable.dart';

abstract class SiteNotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteNotesFetched extends SiteNotesEvent {
  final int siteId;
  SiteNotesFetched({required this.siteId});

  @override
  List<Object?> get props => [siteId];
}
