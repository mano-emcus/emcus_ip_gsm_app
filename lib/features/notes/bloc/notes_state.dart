import 'package:equatable/equatable.dart';
import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';

abstract class NotesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesSuccess extends NotesState {
  NotesSuccess({required this.notes, required this.message});
  final List<NoteEntry> notes;
  final String message;

  @override
  List<Object?> get props => [notes, message];
}

class NotesFailure extends NotesState {
  NotesFailure({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
} 