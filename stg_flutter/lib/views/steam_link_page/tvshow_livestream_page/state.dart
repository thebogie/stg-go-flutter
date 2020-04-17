import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/globalbasestate/state.dart';
import 'package:stg_flutter/models/base_api_model/tvshow_comment.dart';
import 'package:stg_flutter/models/base_api_model/tvshow_stream_link.dart';
import 'package:stg_flutter/models/episodemodel.dart';
import 'package:stg_flutter/models/tvdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TvShowLiveStreamPageState
    implements GlobalBaseState, Cloneable<TvShowLiveStreamPageState> {
  GlobalKey<ScaffoldState> scaffold;
  int tvid;
  String mediaName;
  Season season;
  CrossFadeState isExpanded;
  int episodeNumber;
  TvShowStreamLinks streamLinks;
  String streamAddress;
  StreamLinkType streamLinkType;
  Episode selectedEpisode;
  TvShowComments comments;
  TextEditingController commentController;
  YoutubePlayerController youtubePlayerController;
  ScrollController episodelistController;
  ChewieController chewieController;
  TabController tabController;
  bool showBottom;
  List<VideoPlayerController> videoControllers;
  SharedPreferences preferences;

  @override
  TvShowLiveStreamPageState clone() {
    return TvShowLiveStreamPageState()
      ..scaffold = scaffold
      ..mediaName = mediaName
      ..tvid = tvid
      ..season = season
      ..episodeNumber = episodeNumber
      ..selectedEpisode = selectedEpisode
      ..streamLinks = streamLinks
      ..streamLinkType = streamLinkType
      ..streamAddress = streamAddress
      ..comments = comments
      ..chewieController = chewieController
      ..youtubePlayerController = youtubePlayerController
      ..episodelistController = episodelistController
      ..commentController = commentController
      ..videoControllers = videoControllers
      ..tabController = tabController
      ..isExpanded = isExpanded
      ..showBottom = showBottom
      ..user = user
      ..preferences = preferences;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  FirebaseUser user;
}

TvShowLiveStreamPageState initState(Map<String, dynamic> args) {
  TvShowLiveStreamPageState state = TvShowLiveStreamPageState();
  Episode _episode = args['episode'];
  state.mediaName = args['name'];
  state.tvid = args['tvid'];
  state.season = args['season'];
  if (_episode != null) {
    state.episodeNumber = _episode.episodeNumber;
    state.selectedEpisode = _episode;
  }
  state.isExpanded = CrossFadeState.showFirst;
  state.scaffold = GlobalKey<ScaffoldState>(debugLabel: '_SeasonLinkPagekey');
  state.showBottom = false;
  return state;
}
