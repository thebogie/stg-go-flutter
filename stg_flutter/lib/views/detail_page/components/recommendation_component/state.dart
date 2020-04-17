import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/videolist.dart';
import 'package:stg_flutter/views/detail_page/state.dart';

class RecommendationsState implements Cloneable<RecommendationsState> {
  List<VideoListResult> recommendations;
  @override
  RecommendationsState clone() {
    return RecommendationsState();
  }
}

class RecommendationsConnector
    extends ConnOp<MovieDetailPageState, RecommendationsState> {
  @override
  RecommendationsState get(MovieDetailPageState state) {
    RecommendationsState substate = new RecommendationsState();
    substate.recommendations = state.detail?.recommendations?.results ?? [];
    return substate;
  }
}
