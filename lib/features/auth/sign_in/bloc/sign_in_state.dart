import 'package:equatable/equatable.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/models/sign_in_response.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {

  const SignInSuccess({
    required this.message,
    required this.signInData,
  });
  final String message;
  final SignInData signInData;

  @override
  List<Object> get props => [message, signInData];
}

class SignInFailure extends SignInState {

  const SignInFailure({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
} 