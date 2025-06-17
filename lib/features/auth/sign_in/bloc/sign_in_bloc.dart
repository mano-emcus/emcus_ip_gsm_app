import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_event.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_repository.dart';
import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({SignInRepository? signInRepository, AuthManager? authManager})
    : _signInRepository = signInRepository ?? SignInRepository(),
      _authManager = authManager ?? AuthManager(),
      super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
  }
  final SignInRepository _signInRepository;
  final AuthManager _authManager;

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
        final signInData = response.data.first;

        // Store tokens in SharedPreferences
        await _authManager.storeAuthTokens(
          idToken: signInData.idToken,
          accessToken: signInData.accessToken,
          refreshToken: signInData.refreshToken,
        );

        emit(SignInSuccess(message: response.message, signInData: signInData));
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
