import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:stg_flutter/actions/apihelper.dart';
import 'package:stg_flutter/models/combinedcredits.dart';
import 'package:stg_flutter/models/enums/media_type.dart';
import 'action.dart';
import 'state.dart';

Effect<PeopleDetailPageState> buildEffect() {
  return combineEffects(<Object, Effect<PeopleDetailPageState>>{
    PeopleDetailPageAction.action: _onAction,
    PeopleDetailPageAction.cellTapped: _cellTapped,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<PeopleDetailPageState> ctx) {}
Future _onInit(Action action, Context<PeopleDetailPageState> ctx) async {
  int id = ctx.state.peopleid;
  await Future.delayed(Duration(milliseconds: 200), () async {
    var r = await ApiHelper.getPeopleDetail(id, appendToResponse: 'images');
    if (r != null) ctx.dispatch(PeopleDetailPageActionCreator.onInit(r));
    var r2 = await ApiHelper.getCombinedCredits(id);
    if (r2 != null) {
      var cast = List<CastData>();
      cast = new List<CastData>()..addAll(r2.cast);
      cast.sort((a, b) => b.voteCount.compareTo(a.voteCount));
      r2.cast = new List<CastData>()..addAll(r2.cast);
      r2.cast.sort((a, b) {
        String date1 = a.mediaType == 'movie' ? a.releaseDate : a.firstAirDate;
        String date2 = b.mediaType == 'movie' ? b.releaseDate : b.firstAirDate;
        date1 = date1 == null || date1?.isEmpty == true ? '2099-01-01' : date1;
        date2 = date2 == null || date2?.isEmpty == true ? '2099-01-01' : date2;
        DateTime time1 = DateTime.parse(date1);
        DateTime time2 = DateTime.parse(date2);
        return time2.year == time1.year
            ? (time2.month > time1.month ? 1 : -1)
            : (time2.year > time1.year ? 1 : -1);
      });
      ctx.dispatch(PeopleDetailPageActionCreator.onSetCreditModel(r2, cast));
    }
  });
}

void _cellTapped(Action action, Context<PeopleDetailPageState> ctx) async {
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
  //Page page = type == MediaType.movie ? MovieDetailPage() : TVDetailPage();
  await Navigator.of(ctx.context).pushNamed(pagename, arguments: data);
}
