part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignupEvent extends AuthEvent {
  final SignUp signup;
  const AuthSignupEvent(this.signup);

  @override
  List<Object> get props => [signup];
}

class AuthForgetPasswordEvent extends AuthEvent {
  final ForgetPassword forgetPassword;
  const AuthForgetPasswordEvent(this.forgetPassword);

  @override
  List<Object> get props => [forgetPassword];
}
