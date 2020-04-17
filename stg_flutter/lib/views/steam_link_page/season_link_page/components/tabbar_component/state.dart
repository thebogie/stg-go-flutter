import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/models/tvdetail.dart';
import 'package:stg_flutter/views/steam_link_page/season_link_page/state.dart';

class TabbarState implements Cloneable<TabbarState> {
  TabController tabController;
  List<Season> seasons;
  @override
  TabbarState clone() {
    return TabbarState();
  }
}

class TabbarConnector extends ConnOp<SeasonLinkPageState, TabbarState> {
  @override
  TabbarState get(SeasonLinkPageState state) {
    TabbarState mstate = TabbarState();
    mstate.tabController = state.tabController;
    mstate.seasons = state.detail?.seasons ?? [];
    return mstate;
  }
}
