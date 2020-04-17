import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/episodemodel.dart';

class EpisodeHeaderState implements Cloneable<EpisodeHeaderState> {
  Episode episode;
  EpisodeHeaderState({this.episode});

  @override
  EpisodeHeaderState clone() {
    return EpisodeHeaderState();
  }
}

EpisodeHeaderState initState(Map<String, dynamic> args) {
  return EpisodeHeaderState();
}
