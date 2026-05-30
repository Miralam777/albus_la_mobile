import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class BadReqFailure extends Failure {}

class UnauthFailure extends Failure {}

class NotFoundFailure extends Failure {}

class EmailNotVerifiedFailure extends Failure {}

class NotAcceptableFailure extends Failure {}

class UnexpectedFailure extends Failure {}

class ServerFailure extends Failure {}

class AlreadyInUseFailure extends Failure {}

class WeakPasswordFailure extends Failure {}

class WrongPasswordFailure extends Failure {}

class OfflineFailure extends Failure {}

class EmptyCacheFailure extends Failure {}
