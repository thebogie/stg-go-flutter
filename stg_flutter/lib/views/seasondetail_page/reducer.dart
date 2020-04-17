import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/episodemodel.dart';
import 'package:stg_flutter/models/seasondetail.dart';
import 'package:stg_flutter/views/seasondetail_page/components/seasoncast_component/state.dart';

import 'action.dart';
import 'state.dart';

Reducer<SeasonDetailPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<SeasonDetailPageState>>{
      SeasonDetailPageAction.action: _onAction,
      SeasonDetailPageAction.seasonDetailChanged:_onSeasonDetailChanged
    },
  );
}

SeasonDetailPageState _onAction(SeasonDetailPageState state, Action action) {
  final SeasonDetailPageState newState = state.clone();
  return newState;
}
SeasonDetailPageState _onSeasonDetailChanged(SeasonDetailPageState state, Action action) {
  final SeasonDetailModel model=action.payload??SeasonDetailModel.fromParams(episodes: List<Episode>());
  final SeasonDetailPageState newState = state.clone();
  newState.seasonDetailModel=model;
  newState.seasonCastState=new SeasonCastState(castData: model.credits.cast);
  return newState;
}
