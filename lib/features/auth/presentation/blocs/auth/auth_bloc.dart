import 'package:albus_la_mobile/core/errors/errors.dart';
import 'package:albus_la_mobile/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:albus_la_mobile/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:albus_la_mobile/features/auth/helpers/auth_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase signup;
  final ForgetPasswordUsecase forgetPassword;

  AuthBloc(this.signup, this.forgetPassword) : super(AuthBlocInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthSignupEvent) {
        emit(AuthLoading());
        final signupOrFailure = await signup.call(event.signup);
        emit(_mapSuccessOrFailureToState(signupOrFailure));
      } else if (event is AuthForgetPasswordEvent) {
        emit(AuthLoading());
        final doneOrFailure = await forgetPassword.call(event.forgetPassword);
        emit(_mapSuccessOrFailureToState(doneOrFailure));
      }
    });
  }

  AuthState _mapSuccessOrFailureToState(Either<Failure, Unit> either) {
    return either.fold((failure) => AuthFailure(failure), (_) => AuthSuccess());
  }
}
