import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/actions/adapt.dart';
import 'package:stg_flutter/generated/i18n.dart';
import 'package:stg_flutter/style/themestyle.dart';
import 'package:stg_flutter/views/coming_page/action.dart';

import 'state.dart';

Widget buildView(TabState state, Dispatch dispatch, ViewService viewService) {
  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);
  return Container(
      child: TabBar(
    onTap: (i) {
      if (i == 0)
        dispatch(ComingPageActionCreator.onFilterChanged(true));
      else
        dispatch(ComingPageActionCreator.onFilterChanged(false));
    },
    indicatorSize: TabBarIndicatorSize.label,
    indicatorColor: _theme.tabBarTheme.labelColor,
    labelColor: _theme.tabBarTheme.labelColor,
    unselectedLabelColor: _theme.tabBarTheme.unselectedLabelColor,
    labelStyle: TextStyle(fontSize: Adapt.px(35), fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(color: Colors.grey),
    tabs: <Widget>[
      Tab(
        text: I18n.of(viewService.context).movies,
      ),
      Tab(
        text: I18n.of(viewService.context).tvShows,
      )
    ],
  ));
}
