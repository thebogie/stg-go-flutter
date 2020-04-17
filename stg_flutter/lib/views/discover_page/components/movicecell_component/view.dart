import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stg_flutter/actions/adapt.dart';
import 'package:stg_flutter/actions/imageurl.dart';
import 'package:stg_flutter/actions/votecolorhelper.dart';
import 'package:stg_flutter/models/enums/imagesize.dart';
import 'package:stg_flutter/models/videolist.dart';
import 'package:stg_flutter/style/themestyle.dart';
import 'package:stg_flutter/views/discover_page/action.dart';

import 'state.dart';

Widget buildView(
    VideoCellState state, Dispatch dispatch, ViewService viewService) {
  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);
  final VideoListResult d = state.videodata;
  if (d == null) return SizedBox();
  return GestureDetector(
    key: ValueKey(d.name),
    child: Container(
      padding: EdgeInsets.fromLTRB(Adapt.px(20), 0, Adapt.px(20), Adapt.px(30)),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: Adapt.px(260),
              height: Adapt.px(400),
              decoration: BoxDecoration(
                color: _theme.primaryColorLight,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    ImageUrl.getUrl(d.posterPath, ImageSize.w300),
                  ),
                ),
              ),
            ),
            _Info(
              data: d,
              isMovie: state.isMovie,
            ),
          ],
        ),
      ),
    ),
    onTap: () => dispatch(
        DiscoverPageActionCreator.onVideoCellTapped(d.id, d.posterPath)),
  );
}

class _RateProgressIndicator extends StatelessWidget {
  final double voteAverage;
  const _RateProgressIndicator({this.voteAverage});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adapt.px(80),
      height: Adapt.px(80),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: Adapt.px(80),
              height: Adapt.px(80),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(
                  Adapt.px(40),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
                width: Adapt.px(60),
                height: Adapt.px(60),
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      VoteColorHelper.getColor(voteAverage)),
                  backgroundColor: Colors.grey,
                  value: voteAverage / 10.0,
                )),
          ),
          Center(
            child: Container(
                width: Adapt.px(60),
                height: Adapt.px(60),
                child: Center(
                  child: Text(
                    (voteAverage * 10.0).floor().toString() + '%',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: Adapt.px(20),
                        color: Colors.white),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final VideoListResult data;
  final bool isMovie;
  const _Info({this.data, this.isMovie});
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Container(
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _RateProgressIndicator(voteAverage: data.voteAverage),
              SizedBox(width: Adapt.px(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: Adapt.screenW() - Adapt.px(450),
                    child: Text(
                      (isMovie ? data.title : data.name) ?? '',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: Adapt.px(26)),
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd().format(DateTime.tryParse((isMovie
                        ? _changeDatetime(data.releaseDate)
                        : _changeDatetime(data.firstAirDate)))),
                    style: TextStyle(
                        color: _theme.textTheme.subtitle1.color,
                        fontSize: Adapt.px(20)),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: Adapt.px(20)),
          Container(
            width: Adapt.screenW() - Adapt.px(360),
            child: Text(
              data.overview ?? '',
              softWrap: true,
              maxLines: 7,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

String _changeDatetime(String s1) {
  return s1 == null || s1 == '' ? '1900-01-01' : s1;
}
