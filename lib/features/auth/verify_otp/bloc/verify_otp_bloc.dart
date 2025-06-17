import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_event.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_state.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_repository.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc({VerifyOtpRepository? verifyOtpRepository})
    : _verifyOtpRepository = verifyOtpRepository ?? VerifyOtpRepository(),
      super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
  }
  final VerifyOtpRepository _verifyOtpRepository;

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpLoading());
    try {
      final response = await _verifyOtpRepository.verifyCode(
        email: event.email,
        confirmationCode: event.confirmationCode,
      );

      if (response.statusCode == 1) {
        emit(
          VerifyOtpSuccess(
            message: response.data.first.message,
            session: response.data.first.response.session,
          ),
        );
      } else {
        emit(VerifyOtpFailure(error: response.message));
      }
    } catch (e) {
      emit(VerifyOtpFailure(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _verifyOtpRepository.dispose();
    return super.close();
  }
}
