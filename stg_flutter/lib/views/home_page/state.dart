import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:stg_flutter/models/base_api_model/base_movie.dart';
import 'package:stg_flutter/models/base_api_model/base_tvshow.dart';
import 'package:stg_flutter/models/searchresult.dart';
import 'package:stg_flutter/models/videolist.dart';

class HomePageState implements Cloneable<HomePageState> {
  VideoListModel movie;
  VideoListModel tv;
  VideoListModel popularMovies;
  VideoListModel popularTVShows;
  BaseMovieModel shareMovies;
  BaseTvShowModel shareTvshows;
  SearchResultModel trending;
  ScrollController scrollController;
  bool showHeaderMovie;
  bool showPopMovie;
  bool showShareMovie;
  AnimationController animatedController;

  @override
  HomePageState clone() {
    return HomePageState()
      ..tv = tv
      ..movie = movie
      ..popularMovies = popularMovies
      ..popularTVShows = popularTVShows
      ..showHeaderMovie = showHeaderMovie
      ..showPopMovie = showPopMovie
      ..shareMovies = shareMovies
      ..shareTvshows = shareTvshows
      ..showShareMovie = showShareMovie
      ..trending = trending
      ..scrollController = scrollController
      ..animatedController = animatedController;
  }
}

HomePageState initState(Map<String, dynamic> args) {
  var state = HomePageState();
  state.movie = new VideoListModel.fromParams(results: List<VideoListResult>());
  state.tv = new VideoListModel.fromParams(results: List<VideoListResult>());
  state.popularMovies =
      new VideoListModel.fromParams(results: List<VideoListResult>());
  state.popularTVShows =
      new VideoListModel.fromParams(results: List<VideoListResult>());
  state.trending = SearchResultModel.fromParams(results: []);
  state.showPopMovie = true;
  state.showHeaderMovie = true;
  state.showShareMovie = true;
  return state;
}
