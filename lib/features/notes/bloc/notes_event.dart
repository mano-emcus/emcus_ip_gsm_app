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
  });
  
  final String noteTitle;
  final String noteContent;
  
  @override
  List<Object?> get props => [noteTitle, noteContent];
} 