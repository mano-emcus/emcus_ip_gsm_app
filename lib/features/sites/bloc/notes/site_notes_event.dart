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

class SiteNotesFilterChanged extends SiteNotesEvent {
  SiteNotesFilterChanged({required this.filter});
  final String filter;

  @override
  List<Object?> get props => [filter];
}

class SiteNoteCreated extends SiteNotesEvent {
  SiteNoteCreated({
    required this.siteId,
    required this.noteTitle,
    required this.noteContent,
    required this.category,
  });
  final int siteId;
  final String noteTitle;
  final String noteContent;
  final String category;

  @override
  List<Object?> get props => [siteId, noteTitle, noteContent, category];
}
