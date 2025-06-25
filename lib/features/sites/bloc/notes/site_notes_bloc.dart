import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_event.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_state.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_repository.dart';

class SiteNotesBloc extends Bloc<SiteNotesEvent, SiteNotesState> {
  SiteNotesBloc({SiteNoteRepository? siteNoteRepository})
      : _siteNoteRepository = siteNoteRepository ?? SiteNoteRepository(),
        super(SiteNoteInitial()) {
    on<SiteNotesFetched>(_onSiteNotesFetched);
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
}
