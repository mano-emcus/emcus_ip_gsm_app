import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_event.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository _signInRepository;

  SignInBloc({SignInRepository? signInRepository})
      : _signInRepository = signInRepository ?? SignInRepository(),
        super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      final response = await _signInRepository.signIn(
        email: event.email,
        password: event.password,
      );
      
      if (response.statusCode == 1) {
        emit(SignInSuccess(
          message: response.message,
          signInData: response.data.first,
        ));
      } else {
        emit(SignInFailure(error: response.message));
      }
    } catch (e) {
      emit(SignInFailure(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _signInRepository.dispose();
    return super.close();
  }
} 