import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/review_remote_data_source.dart';
import '../../../data/models/review_model.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRemoteDataSource _dataSource;

  ReviewBloc(this._dataSource) : super(ReviewInitial()) {
    on<FetchReviewsEvent>(_onFetchReviews);
    on<AddReviewEvent>(_onAddReview);
    on<UpdateReviewEvent>(_onUpdateReview);
    on<DeleteReviewEvent>(_onDeleteReview);
  }

  List<ReviewModel> get _currentReviews {
    final s = state;
    if (s is ReviewsLoaded) return s.reviews;
    if (s is ReviewOperationSuccess) return s.reviews;
    if (s is ReviewError) return s.previousReviews;
    return [];
  }

  Future<void> _onFetchReviews(
    FetchReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      final reviews = await _dataSource.fetchReviews();
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(
    AddReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final previous = _currentReviews;
    emit(ReviewLoading());
    try {
      final created = await _dataSource.addReview(event.review);
      final updated = [created, ...previous];
      emit(
        ReviewOperationSuccess(
          'Verdict filed. The director has been blamed. 🎬',
          updated,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString(), previousReviews: previous));
    }
  }

  Future<void> _onUpdateReview(
    UpdateReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final previous = _currentReviews;
    emit(ReviewLoading());
    try {
      final updated = await _dataSource.updateReview(event.review);
      final updatedList = previous
          .map((r) => r.id == updated.id ? updated : r)
          .toList();
      emit(
        ReviewOperationSuccess(
          'Verdict updated. Still their fault. ✏️',
          updatedList,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString(), previousReviews: previous));
    }
  }

  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final previous = _currentReviews;
    emit(ReviewLoading());
    try {
      await _dataSource.deleteReview(event.reviewId);
      final updatedList = previous
          .where((r) => r.id != event.reviewId)
          .toList();
      emit(
        ReviewOperationSuccess(
          'Review deleted. The director walks free... for now. 🗑️',
          updatedList,
        ),
      );
    } catch (e) {
      emit(ReviewError(e.toString(), previousReviews: previous));
    }
  }
}
