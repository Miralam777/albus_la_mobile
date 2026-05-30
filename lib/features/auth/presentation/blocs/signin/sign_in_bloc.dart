import 'package:albus_la_mobile/core/errors/errors.dart';
import 'package:albus_la_mobile/features/auth/domain/entities/user.dart';
import 'package:albus_la_mobile/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:albus_la_mobile/features/auth/helpers/sign_in.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

// TODO: remove this bloc

@lazySingleton
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUsecase signin;
  SignInBloc(this.signin) : super(SignInInitial()) {
    on<SignInEvent>((event, emit) async {
      if (event is SignInUserEvent) {
        emit(SignInLoading());
        final signinOrFailure = await signin.call(event.signin);
        emit(_mapSigninOrFailureToState(signinOrFailure));
      }
    });
  }

  SignInState _mapSigninOrFailureToState(Either<Failure, User> either) {
    return either.fold(
      (failure) => SignInFailure(failure),
      (user) => SignISuccess(user),
    );
  }
}
