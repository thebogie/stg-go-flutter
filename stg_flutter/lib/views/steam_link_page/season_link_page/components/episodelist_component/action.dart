import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/episodemodel.dart';
import 'package:stg_flutter/models/tvdetail.dart';

enum EpisodeListAction {
  action,
  episodeCellTapped,
  updateSeason,
}

class EpisodeListActionCreator {
  static Action onAction() {
    return const Action(EpisodeListAction.action);
  }

  static Action updateSeason(Season d) {
    return Action(EpisodeListAction.updateSeason, payload: d);
  }

  static Action onEpisodeCellTapped(Episode d) {
    return Action(EpisodeListAction.episodeCellTapped, payload: d);
  }
}
