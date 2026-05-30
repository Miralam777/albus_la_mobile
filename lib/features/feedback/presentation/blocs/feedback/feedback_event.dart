part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class PostFeedbackEvent extends FeedbackEvent {
  final AppFeedback feedback;
  const PostFeedbackEvent(this.feedback);

  @override
  List<Object> get props => [feedback];
}
