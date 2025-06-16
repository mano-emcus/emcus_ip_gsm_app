import 'package:equatable/equatable.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final String message;
  final String session;

  const VerifyOtpSuccess({
    required this.message,
    required this.session,
  });

  @override
  List<Object> get props => [message, session];
}

class VerifyOtpFailure extends VerifyOtpState {
  final String error;

  const VerifyOtpFailure({required this.error});

  @override
  List<Object> get props => [error];
} 