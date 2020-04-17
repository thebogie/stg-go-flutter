import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/videolist.dart';
import 'package:stg_flutter/views/tvdetail_page/state.dart';

class RecommendationState implements Cloneable<RecommendationState> {
  List<VideoListResult> recommendations;
  @override
  RecommendationState clone() {
    return RecommendationState();
  }
}

class RecommendationConnector
    extends ConnOp<TVDetailPageState, RecommendationState> {
  @override
  RecommendationState get(TVDetailPageState state) {
    RecommendationState mstate = RecommendationState();
    mstate.recommendations = state.tvDetailModel?.recommendations?.results;
    return mstate;
  }
}
