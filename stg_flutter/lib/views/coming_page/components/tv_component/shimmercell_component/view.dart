import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/actions/adapt.dart';
import 'package:stg_flutter/style/themestyle.dart';
import 'package:shimmer/shimmer.dart';

import 'state.dart';

Widget buildView(
    ShimmerCellState state, Dispatch dispatch, ViewService viewService) {
  final MediaQueryData _mediaQuery = MediaQuery.of(viewService.context);
  final ThemeData _theme = _mediaQuery.platformBrightness == Brightness.light
      ? ThemeStyle.lightTheme
      : ThemeStyle.darkTheme;

  return Offstage(
      offstage: state.showShimmer,
      child: Shimmer.fromColors(
        baseColor: _theme.primaryColorDark,
        highlightColor: _theme.primaryColorLight,
        child: Column(
          children: <Widget>[
            _ShimmerCell(),
            _ShimmerCell(),
            _ShimmerCell(),
            _ShimmerCell(),
          ],
        ),
      ));
}

class _ShimmerCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: Adapt.px(120),
              height: Adapt.px(180),
              color: Colors.grey[200]),
          SizedBox(
            width: Adapt.px(20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: Adapt.px(350),
                height: Adapt.px(30),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: Adapt.px(150),
                height: Adapt.px(24),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: Adapt.px(8),
              ),
              SizedBox(
                height: Adapt.px(8),
              ),
              Container(
                width: Adapt.screenW() - Adapt.px(300),
                height: Adapt.px(24),
                color: Colors.grey[200],
              ),
              SizedBox(
                height: Adapt.px(8),
              ),
              Container(
                width: Adapt.screenW() - Adapt.px(300),
                height: Adapt.px(24),
                color: Colors.grey[200],
              )
            ],
          )
        ],
      ),
    );
  }
}
