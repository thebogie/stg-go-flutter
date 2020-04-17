import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/globalbasestate/state.dart';
import 'package:stg_flutter/models/imagemodel.dart';
import 'package:stg_flutter/models/media_accountstatemodel.dart';
import 'package:stg_flutter/models/moviedetail.dart';
import 'package:stg_flutter/models/review.dart';
import 'package:stg_flutter/models/videomodel.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieDetailPageState
    implements GlobalBaseState, Cloneable<MovieDetailPageState> {
  GlobalKey<ScaffoldState> scaffoldkey;
  MovieDetailModel movieDetailModel;
  String backdropPic;
  String title;
  String posterPic;
  int movieid;
  Color mainColor;
  Color tabTintColor;
  PaletteGenerator palette;
  ImageModel imagesmodel;
  ReviewModel reviewModel;
  VideoModel videomodel;
  ScrollController scrollController;
  MediaAccountStateModel accountState;
  AnimationController animationController;

  @override
  MovieDetailPageState clone() {
    return MovieDetailPageState()
      ..scaffoldkey = scaffoldkey
      ..movieDetailModel = movieDetailModel
      ..mainColor = mainColor
      ..tabTintColor = tabTintColor
      ..palette = palette
      ..movieid = movieid
      ..reviewModel = reviewModel
      ..imagesmodel = imagesmodel
      ..videomodel = videomodel
      ..backdropPic = backdropPic
      ..posterPic = posterPic
      ..title = title
      ..scrollController = scrollController
      ..accountState = accountState
      ..animationController = animationController;
  }

  @override
  Color themeColor = Colors.black;

  @override
  Locale locale;

  @override
  FirebaseUser user;
}

MovieDetailPageState initState(Map<String, dynamic> args) {
  Random random = new Random(DateTime.now().millisecondsSinceEpoch);
  var state = MovieDetailPageState();
  state.scaffoldkey = GlobalKey<ScaffoldState>();
  state.movieid = args['movieid'];
  if (args['bgpic'] != null) state.backdropPic = args['bgpic'];
  if (args['posterpic'] != null) state.posterPic = args['posterpic'];
  if (args['title'] != null) state.title = args['title'];
  state.movieDetailModel = new MovieDetailModel.fromParams();
  state.mainColor = Color.fromRGBO(
      random.nextInt(200), random.nextInt(100), random.nextInt(255), 1);
  state.tabTintColor = Color.fromRGBO(
      random.nextInt(200), random.nextInt(100), random.nextInt(255), 1);
  state.palette = new PaletteGenerator.fromColors(
      List<PaletteColor>()..add(new PaletteColor(Colors.black87, 0)));
  state.imagesmodel = new ImageModel.fromParams(
      posters: List<ImageData>(), backdrops: List<ImageData>());
  state.reviewModel = new ReviewModel.fromParams(results: List<ReviewResult>());
  state.videomodel = new VideoModel.fromParams(results: List<VideoResult>());
  state.accountState =
      new MediaAccountStateModel.fromParams(favorite: false, watchlist: false);
  return state;
}
