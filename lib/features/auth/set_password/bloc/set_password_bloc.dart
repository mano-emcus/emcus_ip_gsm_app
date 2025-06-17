import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_event.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_state.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_repository.dart';

class SetPasswordBloc extends Bloc<SetPasswordEvent, SetPasswordState> {
  SetPasswordBloc({SetPasswordRepository? setPasswordRepository})
    : _setPasswordRepository = setPasswordRepository ?? SetPasswordRepository(),
      super(SetPasswordInitial()) {
    on<SetPasswordSubmitted>(_onSetPasswordSubmitted);
  }
  final SetPasswordRepository _setPasswordRepository;

  Future<void> _onSetPasswordSubmitted(
    SetPasswordSubmitted event,
    Emitter<SetPasswordState> emit,
  ) async {
    emit(SetPasswordLoading());
    try {
      final response = await _setPasswordRepository.updatePassword(
        email: event.email,
        password: event.password,
      );

      if (response.statusCode == 1) {
        emit(SetPasswordSuccess(message: response.message));
      } else {
        emit(SetPasswordFailure(error: response.message));
      }
    } catch (e) {
      emit(SetPasswordFailure(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _setPasswordRepository.dispose();
    return super.close();
  }
}
