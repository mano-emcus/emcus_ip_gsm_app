import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_event.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_state.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_repository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({required NotesRepository notesRepository})
    : _notesRepository = notesRepository,
      super(NotesInitial()) {
    on<NotesFetched>(_onNotesFetched);
    on<NoteAdded>(_onNoteAdded);
  }
  final NotesRepository _notesRepository;

  Future<void> _onNotesFetched(
    NotesFetched event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    try {
      final response = await _notesRepository.fetchNotes();

      if (response.statusCode == 1) {
        emit(NotesSuccess(notes: response.data, message: response.message));
      } else {
        emit(NotesFailure(error: response.message));
      }
    } catch (e) {
      emit(NotesFailure(error: e.toString()));
    }
  }

  Future<void> _onNoteAdded(
    NoteAdded event,
    Emitter<NotesState> emit,
  ) async {
    emit(NoteCreating());
    try {
      final response = await _notesRepository.createNote(
        noteTitle: event.noteTitle,
        noteContent: event.noteContent,
        noteTag: event.noteTag,
      );

      final message = response['message'] ?? 'Note created successfully';
      emit(NoteCreated(message: message));
      
      // After successful creation, fetch the updated notes list
      add(NotesFetched());
    } catch (e) {
      emit(NoteCreationFailure(error: e.toString()));
    }
  }
} 