import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_event.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_state.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required RegisterRepository registerRepository})
    : _registerRepository = registerRepository,
      super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }
  final RegisterRepository _registerRepository;

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final response = await _registerRepository.register(
        fullName: event.fullName,
        companyName: 'Gemini',
        email: event.email,
        password: event.password,
      );

      if (response.statusCode == 1) {
        emit(RegisterSuccess(message: response.message));
      } else {
        emit(RegisterFailure(error: response.message));
      }
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _registerRepository.dispose();
    return super.close();
  }
}
