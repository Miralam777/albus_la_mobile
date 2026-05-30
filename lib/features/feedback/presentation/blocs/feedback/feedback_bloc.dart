import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/errors.dart';
import '../../../domain/entities/app_feedback.dart';
import '../../../domain/usecases/post_feedback_usecase.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

@lazySingleton
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final PostFeedbackUsecase postUsecase;

  FeedbackBloc(this.postUsecase) : super(FeedbackInitial()) {
    on<FeedbackEvent>((event, emit) async {
      if (event is PostFeedbackEvent) {
        emit(FeedbackPosting());
        final postedOrFailure = await postUsecase.call(event.feedback);
        emit(_mapPostedOrFailureToState(postedOrFailure));
      }
    });
  }

  FeedbackState _mapPostedOrFailureToState(Either<Failure, Unit> either) =>
      either.fold(
          (failure) => FeedbackFailure(failure), (posted) => FeedbackPosted());
}
