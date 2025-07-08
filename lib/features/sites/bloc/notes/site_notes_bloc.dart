import 'package:emcus_ipgsm_app/features/notes/models/note_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_state.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_repository.dart';

class SiteNotesBloc extends Bloc<SiteNotesEvent, SiteNotesState> {
  SiteNotesBloc({required SiteNoteRepository siteNoteRepository})
    : _siteNoteRepository = siteNoteRepository,
      super(SiteNoteInitial()) {
    on<SiteNotesFetched>(_onSiteNotesFetched);
    on<SiteNoteCreated>(_onSiteNoteCreated);
    on<SiteNotesFilterChanged>(_onSiteNotesFilterChanged);
  }
  final SiteNoteRepository _siteNoteRepository;
  List<NoteEntry> _allNotes = [];

  Future<void> _onSiteNotesFetched(
    SiteNotesFetched event,
    Emitter<SiteNotesState> emit,
  ) async {
    emit(SiteNoteLoading());
    try {
      final response = await _siteNoteRepository.fetchSiteNotes(
        siteId: event.siteId,
      );
      _allNotes = response.data;
      if (response.statusCode == 1) {
        emit(SiteNoteSuccess(notes: _allNotes));
      } else {
        emit(SiteNoteFailure(error: response.message));
      }
    } catch (e) {
      emit(SiteNoteFailure(error: e.toString()));
    }
  }

  Future<void> _onSiteNotesFilterChanged(
    SiteNotesFilterChanged state,
    Emitter<SiteNotesState> emit,
  ) async {
    final filtered = _allNotes.where((note) => note.noteTitle.toLowerCase().contains(state.filter.toLowerCase()) || note.noteContent.toLowerCase().contains(state.filter.toLowerCase())).toList();
    emit(SiteNoteSuccess(notes: filtered));
  }

  Future<void> _onSiteNoteCreated(
    SiteNoteCreated event,
    Emitter<SiteNotesState> emit,
  ) async {
    emit(SiteNoteCreateLoading());
    try {
      final response = await _siteNoteRepository.createSiteNote(
        siteId: event.siteId,
        noteTitle: event.noteTitle,
        noteContent: event.noteContent,
        category: event.category,
      );
      if (response.statusCode == 1) {
        emit(
          SiteNoteCreateSuccess(
            messages: response.data,
            message: response.message,
          ),
        );
        add(SiteNotesFetched(siteId: event.siteId));
      } else {
        emit(SiteNoteCreateFailure(error: response.message));
      }
    } catch (e) {
      emit(SiteNoteCreateFailure(error: e.toString()));
    }
  }
}
