import 'package:emcus_ipgsm_app/features/notes/views/notes_screen.dart';
import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotesFetched extends NotesEvent {
  NotesFetched();
  
  @override
  List<Object?> get props => [];
}

class NoteAdded extends NotesEvent {
  NoteAdded({
    required this.noteTitle,
    required this.noteContent,
    required this.noteTag,
  });
  
  final String noteTitle;
  final String noteContent;
  final NoteCategory noteTag;
  
  @override
  List<Object?> get props => [noteTitle, noteContent, noteTag];
} 