import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';
import 'package:equatable/equatable.dart';

abstract class SiteNotesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteNoteInitial extends SiteNotesState {}

class SiteNoteLoading extends SiteNotesState {}

class SiteNoteSuccess extends SiteNotesState {
  SiteNoteSuccess({required this.notes, required this.message});
  final List<NoteEntry> notes;
  final String message;

  @override
  List<Object?> get props => [notes, message];
}

class SiteNoteFailure extends SiteNotesState {
  SiteNoteFailure({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}

class SiteNoteCreateLoading extends SiteNotesState {}

class SiteNoteCreateSuccess extends SiteNotesState {
  SiteNoteCreateSuccess({required this.notes, required this.message});
  final List<NoteEntry> notes;
  final String message;

  @override
  List<Object?> get props => [notes, message];
}

class SiteNoteCreateFailure extends SiteNotesState {
  SiteNoteCreateFailure({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}
