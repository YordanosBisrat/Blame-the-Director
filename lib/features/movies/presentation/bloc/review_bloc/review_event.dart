import 'package:equatable/equatable.dart';

import '../../../data/models/review_model.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchReviewsEvent extends ReviewEvent {}

class AddReviewEvent extends ReviewEvent {
  final ReviewModel review;
  AddReviewEvent(this.review);

  @override
  List<Object?> get props => [review];
}

class UpdateReviewEvent extends ReviewEvent {
  final ReviewModel review;
  UpdateReviewEvent(this.review);

  @override
  List<Object?> get props => [review];
}

class DeleteReviewEvent extends ReviewEvent {
  final int reviewId;
  DeleteReviewEvent(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}
