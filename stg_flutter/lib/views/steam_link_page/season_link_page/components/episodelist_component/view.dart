import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/actions/adapt.dart';
import 'package:stg_flutter/style/themestyle.dart';
import 'package:shimmer/shimmer.dart';

import 'state.dart';

Widget buildView(
    EpisodeListState state, Dispatch dispatch, ViewService viewService) {
  final _adapter = viewService.buildAdapter();

  return state.episodes != null
      ? MediaQuery.removePadding(
          context: viewService.context,
          removeTop: true,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
            itemCount: _adapter.itemCount,
            separatorBuilder: (_, __) => SizedBox(
              height: Adapt.px(14),
            ),
            itemBuilder: _adapter.itemBuilder,
          ))
      : _ShimmerTabview();
}

class _ShimmerCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _color = Colors.grey[300];
    final _rightWdith = Adapt.screenW() - Adapt.px(300);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: Adapt.px(220),
          height: Adapt.px(130),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(10)),
            color: _color,
          ),
        ),
        SizedBox(width: Adapt.px(20)),
        Container(
            width: Adapt.screenW() - Adapt.px(300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    color: _color, width: Adapt.px(200), height: Adapt.px(30)),
                SizedBox(height: Adapt.px(10)),
                Container(
                    color: _color, width: _rightWdith, height: Adapt.px(20)),
                SizedBox(height: Adapt.px(10)),
                Container(
                    color: _color, width: _rightWdith, height: Adapt.px(20)),
                SizedBox(height: Adapt.px(10)),
                Container(
                    color: _color, width: Adapt.px(400), height: Adapt.px(20)),
              ],
            ))
      ],
    );
  }
}

class _ShimmerTabview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Shimmer.fromColors(
      baseColor: _theme.primaryColorDark,
      highlightColor: _theme.primaryColorLight,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: Column(
            children: <Widget>[
              _ShimmerCell(),
              SizedBox(height: Adapt.px(30)),
              _ShimmerCell(),
              SizedBox(height: Adapt.px(30)),
              _ShimmerCell(),
              SizedBox(height: Adapt.px(30)),
              _ShimmerCell()
            ],
          )),
    );
  }
}
