import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/episodemodel.dart';

class EpisodesState implements Cloneable<EpisodesState> {

 List<Episode> episodes;
 int tvid;

 EpisodesState({this.episodes,this.tvid});

  @override
  EpisodesState clone() {
    return EpisodesState()
    ..episodes=episodes;
  }
}

EpisodesState initState(Map<String, dynamic> args) {
  return EpisodesState();
}
