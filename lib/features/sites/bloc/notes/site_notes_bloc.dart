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
  }
  final SiteNoteRepository _siteNoteRepository;

  Future<void> _onSiteNotesFetched(
    SiteNotesFetched event,
    Emitter<SiteNotesState> emit,
  ) async {
    emit(SiteNoteLoading());
    try {
      final response = await _siteNoteRepository.fetchSiteNotes(siteId: event.siteId);
      if (response.statusCode == 1) {
        emit(SiteNoteSuccess(notes: response.data, message: response.message));
      } else {
        emit(SiteNoteFailure(error: response.message));
      }
    } catch (e) {
      emit(SiteNoteFailure(error: e.toString()));
    }
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
        emit(SiteNoteCreateSuccess(messages: response.data, message: response.message));
        add(SiteNotesFetched(siteId: event.siteId));
      } else {
        emit(SiteNoteCreateFailure(error: response.message));
      }
    } catch (e) {
      emit(SiteNoteCreateFailure(error: e.toString()));
    }
  }
}
