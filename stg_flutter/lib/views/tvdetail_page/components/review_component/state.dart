import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/review.dart';
import 'package:stg_flutter/views/tvdetail_page/state.dart';

class ReviewState implements Cloneable<ReviewState> {
  List<ReviewResult> reviewResults;
  @override
  ReviewState clone() {
    return ReviewState();
  }
}

class ReviewConnector extends ConnOp<TVDetailPageState, ReviewState> {
  @override
  ReviewState get(TVDetailPageState state) {
    ReviewState mstate = ReviewState();
    mstate.reviewResults = state.reviewModel.results;
    return mstate;
  }
}
