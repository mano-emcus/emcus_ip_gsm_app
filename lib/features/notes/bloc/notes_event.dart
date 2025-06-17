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