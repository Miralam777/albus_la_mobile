import 'errors.dart';

// TODO: clean
class ErrorsHelper {
  ErrorsHelper._();

// TODO: hceck all failure and exceptions
  static Exception errorCodeToException(int statusCode) {
    print('=> statusCode: $statusCode');

    // return UnauthException();
    // return BadReqException();
    // return NotFoundException();
    // return EmailNotVerifiedException();
    // return ServerException();
    // return UnexpectedException();

    // return UnauthException();
    // if (statusCode == 200) {
    // statusCode200Func();
    // } else

    switch (statusCode) {
      case 400:
        return BadReqException();

      case 401:
        return UnauthException();

      case 404:
        return NotFoundException();

      case 405:
        return EmailNotVerifiedException();

      case 406:
        return NotAcceptableException();

      case 500:
        return ServerException();

      case 501:
        return AlreadyInUseException();

      case 502:
        return WeakPasswordException();

      case 503:
        return WrongPasswordException();

      default:
        return ServerException();
    }

    // !!!!
    /* if (statusCode == 400) {
      print('400 BadReqException()');
      return BadReqException();
    } else if (statusCode == 401) {
      print('401 UnauthException()');
      return UnauthException();
    } else if (statusCode == 404) {
      print('404 NotFoundException()');
      return NotFoundException();
    } else if (statusCode == 405) {
      print('405 EmailNotVrifiedException()');
      return EmailNotVerifiedException();
    } else if (statusCode == 406) {
      print('406 NotAcceptableException()');
      return NotAcceptableException();
    } else if (statusCode == 500) {
      print('500 ServerException()');
      return ServerException();
    } else {
      print('UnexpectedException()');
      return UnexpectedException();
    } */
  }

// TODO: check all failure and exceptions
  static Failure exceptionToFailure(Object error) {
    switch (error.runtimeType) {
      case BadReqException:
        return BadReqFailure();

      case UnauthException:
        return UnauthFailure();

      case NotFoundException:
        return NotFoundFailure();

      case EmailNotVerifiedException:
        return EmailNotVerifiedFailure();

      case NotAcceptableException:
        return NotAcceptableFailure();

      case ServerException:
        return ServerFailure();

      case AlreadyInUseException:
        return AlreadyInUseFailure();

      case WeakPasswordException:
        return WeakPasswordFailure();

      case WrongPasswordException:
        return WrongPasswordFailure();

      case UnexpectedException:
        return UnexpectedFailure();

      default:
        return UnexpectedFailure();
    }
/*           switch (error.runtimeType) {
          case UnauthException:
            return Left(UnauthFailure());

          case BadReqException:
            return Left(BadReqFailure());

          case NotFoundException:
            return Left(NotFoundFailure());

          case EmailNotVerifiedException:
            return Left(EmailNotVerifiedFailure());

          case ServerException:
            return Left(ServerFailure());

          case UnexpectedException:
            return Left(UnexpectedFailure());

          default:
            return Left(UnexpectedFailure());
        } */
  }
}
