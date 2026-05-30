part of 'sign_in_bloc.dart';

class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInUserEvent extends SignInEvent {
  final SignIn signin;
  const SignInUserEvent(this.signin);

  @override
  List<Object> get props => [signin];
}
