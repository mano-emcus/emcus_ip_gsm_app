import 'package:equatable/equatable.dart';
import 'package:emcus_ipgsm_app/features/sites/models/site_note_entry.dart';

abstract class SiteNotesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteNoteInitial extends SiteNotesState {}

class SiteNoteLoading extends SiteNotesState {}

class SiteNoteSuccess extends SiteNotesState {
  SiteNoteSuccess({required this.notes, required this.message});
  final List<SiteNoteEntry> notes;
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
