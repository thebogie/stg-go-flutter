import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:stg_flutter/models/base_api_model/tvshow_stream_link.dart';
import 'package:stg_flutter/views/steam_link_page/tvshow_livestream_page/state.dart';

class StreamLinkState implements Cloneable<StreamLinkState> {
  ScrollController episodelistController;
  TvShowStreamLinks streamLinks;
  int episodeNumber;
  @override
  StreamLinkState clone() {
    return StreamLinkState();
  }
}

class StreamLinkConnector
    extends ConnOp<TvShowLiveStreamPageState, StreamLinkState> {
  @override
  StreamLinkState get(TvShowLiveStreamPageState state) {
    StreamLinkState substate = new StreamLinkState();
    substate.episodeNumber = state.episodeNumber;
    substate.episodelistController = state.episodelistController;
    substate.streamLinks = state.streamLinks;
    return substate;
  }
}
