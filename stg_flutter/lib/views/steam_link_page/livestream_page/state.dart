import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/globalbasestate/state.dart';
import 'package:stg_flutter/models/base_api_model/movie_comment.dart';
import 'package:stg_flutter/models/base_api_model/movie_stream_link.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveStreamPageState
    implements GlobalBaseState, Cloneable<LiveStreamPageState> {
  int id;
  String name;
  double rated;
  int rateCount;
  String releaseDate;
  String comment;
  String streamAddress;
  FocusNode commentFocusNode;
  MovieComments comments;
  TextEditingController commentController;
  List<VideoPlayerController> videoControllers;
  ChewieController chewieController;
  List<MovieStreamLink> streamLinks;
  StreamLinkType streamLinkType;
  YoutubePlayerController youtubePlayerController;
  bool loading;

  @override
  LiveStreamPageState clone() {
    return LiveStreamPageState()
      ..id = id
      ..name = name
      ..rated = rated
      ..rateCount = rateCount
      ..releaseDate = releaseDate
      ..user = user
      ..streamLinks = streamLinks
      ..comment = comment
      ..comments = comments
      ..streamAddress = streamAddress
      ..streamLinkType = streamLinkType
      ..commentController = commentController
      ..commentFocusNode = commentFocusNode
      ..videoControllers = videoControllers
      ..chewieController = chewieController
      ..youtubePlayerController = youtubePlayerController
      ..loading = loading;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  FirebaseUser user;
}

LiveStreamPageState initState(Map<String, dynamic> args) {
  return LiveStreamPageState()
    ..id = args['id']
    ..name = args['name']
    ..rateCount = args['rateCount']
    ..rated = args['rated']
    ..releaseDate = args['releaseDate']
    ..loading = false;
}
