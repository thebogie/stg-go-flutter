import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/seasondetail.dart';

enum SeasonDetailPageAction { action, seasonDetailChanged }

class SeasonDetailPageActionCreator {
  static Action onAction() {
    return const Action(SeasonDetailPageAction.action);
  }

  static Action onSeasonDetailChanged(SeasonDetailModel s) {
    return Action(SeasonDetailPageAction.seasonDetailChanged, payload: s);
  }
}
