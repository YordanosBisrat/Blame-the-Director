import 'package:equatable/equatable.dart';

import '../../../data/models/review_model.dart';

abstract class ReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  ReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewOperationSuccess extends ReviewState {
  final String message;
  final List<ReviewModel> reviews;
  ReviewOperationSuccess(this.message, this.reviews);

  @override
  List<Object?> get props => [message, reviews];
}

class ReviewError extends ReviewState {
  final String message;
  final List<ReviewModel> previousReviews;
  ReviewError(this.message, {this.previousReviews = const []});

  @override
  List<Object?> get props => [message, previousReviews];
}
