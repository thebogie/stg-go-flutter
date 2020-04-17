import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/tvdetail.dart';
import 'package:stg_flutter/models/videolist.dart';

enum TVCellAction { action, loadSeason, cellTapped }

class TVCellActionCreator {
  static Action onAction() {
    return const Action(TVCellAction.action);
  }

  static Action onLoadSeason(TVDetailModel d) {
    return Action(TVCellAction.loadSeason, payload: d);
  }

  static Action cellTapped(VideoListResult d) {
    return Action(TVCellAction.cellTapped, payload: d);
  }
}
