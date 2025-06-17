import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_event.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_state.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_repository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({NotesRepository? notesRepository})
    : _notesRepository = notesRepository ?? NotesRepository(),
      super(NotesInitial()) {
    on<NotesFetched>(_onNotesFetched);
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
} 