import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:stg_flutter/models/videolist.dart';
import 'package:stg_flutter/views/coming_page/components/tv_component/action.dart';
import 'action.dart';
import 'state.dart';

Effect<TVCellState> buildEffect() {
  return combineEffects(<Object, Effect<TVCellState>>{
    TVCellAction.action: _onAction,
    Lifecycle.initState: _onLoadSeason,
    TVCellAction.cellTapped: _cellTapped,
  });
}

void _onAction(Action action, Context<TVCellState> ctx) {}

Future _onLoadSeason(Action action, Context<TVCellState> ctx) async {
  ctx.broadcast(TVListActionCreator.onLoadSeason(ctx.state.index));
}

void _cellTapped(Action action, Context<TVCellState> ctx) async {
  VideoListResult _d = action.payload;
  if (_d != null)
    await Navigator.of(ctx.context).pushNamed('tvdetailpage', arguments: {
      'tvid': _d.id,
      'bgpic': _d.backdropPath,
      'name': _d.name,
      'posterpic': _d.posterPath
    });
}
