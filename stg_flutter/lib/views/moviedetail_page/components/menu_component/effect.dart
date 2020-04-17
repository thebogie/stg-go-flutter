import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/actions/apihelper.dart';
import 'package:stg_flutter/models/enums/media_type.dart';
import 'package:stg_flutter/views/moviedetail_page/action.dart';
import 'action.dart';
import 'state.dart';

Effect<MenuState> buildEffect() {
  return combineEffects(<Object, Effect<MenuState>>{
    MenuAction.action: _onAction,
    MenuAction.setRating:_setRating,
    MenuAction.setFavorite:_setFavorite,
    MenuAction.setWatchlist:_setWatchlist
  });
}

void _onAction(Action action, Context<MenuState> ctx) {
}

Future _setRating(Action action, Context<MenuState> ctx) async{
  ctx.dispatch(MenuActionCreator.updateRating(action.payload));
  var r=await ApiHelper.rateMovie(ctx.state.id, action.payload);
  if(r)ctx.broadcast(MovieDetailPageActionCreator.showSnackBar('your rating has been saved'));
}

Future _setFavorite(Action action, Context<MenuState> ctx) async{
  final bool f=action.payload;
  ctx.dispatch(MenuActionCreator.updateFavorite(f));
  var r=await ApiHelper.markAsFavorite(ctx.state.id,MediaType.movie, f);
  if(r)ctx.broadcast(MovieDetailPageActionCreator.showSnackBar(f?'has been mark as favorite':'has been removed'));
}

Future _setWatchlist(Action action, Context<MenuState> ctx) async{
  final bool f=action.payload;
  ctx.dispatch(MenuActionCreator.updateWatctlist(f));
  var r=await ApiHelper.addToWatchlist(ctx.state.id,MediaType.movie, f);
  if(r)ctx.broadcast(MovieDetailPageActionCreator.showSnackBar(f?'has been add to your watchlist':'has been removed from your watchlist'));
}
