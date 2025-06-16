import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_event.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_state.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_repository.dart';
import 'package:emcus_ipgsm_app/features/auth/register/models/register_response.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository _registerRepository;

  RegisterBloc({RegisterRepository? registerRepository})
      : _registerRepository = registerRepository ?? RegisterRepository(),
        super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final response = await _registerRepository.register(
        fullName: event.fullName,
        companyName: event.companyName,
        email: event.email,
      );
      
      if (response.statusCode == 1) {
        emit(RegisterSuccess(
          message: response.data.first.message,
        ));
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