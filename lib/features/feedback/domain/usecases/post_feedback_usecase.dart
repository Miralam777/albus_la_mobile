import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/errors.dart';
import '../entities/app_feedback.dart';
import '../repositories/feedback_repository.dart';

@injectable
class PostFeedbackUsecase {
  final FeedbackRepository repository;
  PostFeedbackUsecase(this.repository);

  Future<Either<Failure, Unit>> call(AppFeedback feedback) async =>
      await repository.postFeedback(feedback);
}
