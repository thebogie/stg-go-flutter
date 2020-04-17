import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/searchresult.dart';
import 'package:stg_flutter/views/home_page/state.dart';

class TrendingState implements Cloneable<TrendingState> {
  SearchResultModel trending;
  @override
  TrendingState clone() {
    return TrendingState();
  }
}

class TrendingConnector extends ConnOp<HomePageState, TrendingState> {
  @override
  TrendingState get(HomePageState state) {
    TrendingState mstate = TrendingState();
    mstate.trending = state.trending;
    return mstate;
  }
}
