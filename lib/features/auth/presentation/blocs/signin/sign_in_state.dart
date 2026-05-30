part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignISuccess extends SignInState {
  const SignISuccess(this.user);
  final User user;

  @override
  List<Object> get props => [user];
}

class SignInFailure extends SignInState {
  const SignInFailure(this.failure);
  final Failure failure;

  @override
  List<Object> get props => [failure];
}
