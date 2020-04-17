import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:stg_flutter/actions/apihelper.dart';
import 'package:stg_flutter/actions/base_api.dart';
import 'package:stg_flutter/customwidgets/custom_stfstate.dart';
import 'package:stg_flutter/customwidgets/searchbar_delegate.dart';
import 'package:stg_flutter/models/enums/media_type.dart';
import 'package:stg_flutter/models/enums/time_window.dart';
import 'package:stg_flutter/views/detail_page/page.dart';
import 'package:stg_flutter/views/steam_link_page/allstreamlink_page/page.dart';
import 'package:stg_flutter/views/trending_page/page.dart';
import 'package:stg_flutter/views/tvdetail_page/page.dart';
import 'action.dart';
import 'state.dart';

Effect<HomePageState> buildEffect() {
  return combineEffects(<Object, Effect<HomePageState>>{
    HomePageAction.action: _onAction,
    HomePageAction.moreTapped: _moreTapped,
    HomePageAction.searchBarTapped: _onSearchBarTapped,
    HomePageAction.cellTapped: _onCellTapped,
    HomePageAction.trendingMore: _trendingMore,
    HomePageAction.shareMore: _shareMore,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<HomePageState> ctx) {}

Future _onInit(Action action, Context<HomePageState> ctx) async {
  final ticker = ctx.stfState as CustomstfState;
  ctx.state.animatedController =
      AnimationController(vsync: ticker, duration: Duration(milliseconds: 600));
  ctx.state.scrollController = new ScrollController();
  final _movies = await ApiHelper.getNowPlayingMovie();
  if (_movies != null) ctx.dispatch(HomePageActionCreator.onInitMovie(_movies));
  final _tv = await ApiHelper.getTVOnTheAir();
  if (_tv != null) ctx.dispatch(HomePageActionCreator.onInitTV(_tv));
  final _trending = await ApiHelper.getTrending(MediaType.all, TimeWindow.day);
  if (_trending != null)
    ctx.dispatch(HomePageActionCreator.initTrending(_trending));
  final _shareMovie = await BaseApi.getMovies(pageSize: 10);
  if (_shareMovie != null)
    ctx.dispatch(HomePageActionCreator.initShareMovies(_shareMovie));
  final _sharetv = await BaseApi.getTvShows(pageSize: 10);
  if (_sharetv != null)
    ctx.dispatch(HomePageActionCreator.initShareTvShows(_sharetv));
  final _popMovie = await ApiHelper.getPopularMovies();
  if (_popMovie != null)
    ctx.dispatch(HomePageActionCreator.onInitPopularMovie(_popMovie));
  final _popTv = await ApiHelper.getPopularTVShows();
  if (_popTv != null)
    ctx.dispatch(HomePageActionCreator.onInitPopularTV(_popTv));
}

void _onDispose(Action action, Context<HomePageState> ctx) {
  ctx.state.animatedController.dispose();
  ctx.state.scrollController.dispose();
}

Future _moreTapped(Action action, Context<HomePageState> ctx) async {
  await Navigator.of(ctx.context).pushNamed('MoreMediaPage',
      arguments: {'list': action.payload[0], 'type': action.payload[1]});
}

Future _onSearchBarTapped(Action action, Context<HomePageState> ctx) async {
  await showSearch(context: ctx.context, delegate: SearchBarDelegate());
}

Future _onCellTapped(Action action, Context<HomePageState> ctx) async {
  final MediaType type = action.payload[4];
  final int id = action.payload[0];
  final String bgpic = action.payload[1];
  final String title = action.payload[2];
  final String posterpic = action.payload[3];
  final String pagename =
      type == MediaType.movie ? 'detailpage' : 'tvdetailpage';
  var data = {
    type == MediaType.movie ? 'id' : 'tvid': id,
    'bgpic': type == MediaType.movie ? posterpic : bgpic,
    type == MediaType.movie ? 'title' : 'name': title,
    'posterpic': posterpic
  };
  Page page = type == MediaType.movie ? MovieDetailPage() : TVDetailPage();
  await Navigator.of(ctx.context).push(PageRouteBuilder(
      settings: RouteSettings(name: pagename),
      pageBuilder: (context, animation, secAnimation) {
        return FadeTransition(
          opacity: animation,
          child: page.buildPage(data),
        );
      }));
  //await Navigator.of(ctx.context).pushNamed(pagename, arguments: data);
}

Future _trendingMore(Action action, Context<HomePageState> ctx) async {
  await Navigator.of(ctx.context)
      .push(PageRouteBuilder(pageBuilder: (context, animation, secAnimation) {
    return FadeTransition(
      opacity: animation,
      child: TrendingPage().buildPage({'data': ctx.state.trending}),
    );
  }));
}

Future _shareMore(Action action, Context<HomePageState> ctx) async {
  await Navigator.of(ctx.context)
      .push(PageRouteBuilder(pageBuilder: (context, animation, secAnimation) {
    return FadeTransition(
      opacity: animation,
      child: AllStreamLinkPage().buildPage(
          {'type': ctx.state.showShareMovie ? MediaType.movie : MediaType.tv}),
    );
  }));
}
