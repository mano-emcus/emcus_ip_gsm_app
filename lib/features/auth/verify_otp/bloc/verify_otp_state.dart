import 'package:equatable/equatable.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  const VerifyOtpSuccess({
    required this.message,
    // required this.session,
  });
  final String message;
  // final String session;

  // @override
  // List<Object> get props => [message, session];
  @override
  List<Object> get props => [message];
}

class VerifyOtpFailure extends VerifyOtpState {
  const VerifyOtpFailure({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}
