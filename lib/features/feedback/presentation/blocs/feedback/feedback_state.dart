part of 'feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackPosting extends FeedbackState {}

class FeedbackPosted extends FeedbackState {}

class FeedbackFailure extends FeedbackState {
  final Failure failure;
  const FeedbackFailure(this.failure);
  @override
  List<Object> get props => [failure];
}
