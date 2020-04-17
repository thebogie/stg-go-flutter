import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:stg_flutter/globalbasestate/state.dart';
import 'package:stg_flutter/models/discoversorttype.dart';
import 'package:stg_flutter/models/sortcondition.dart';
import 'package:stg_flutter/models/videolist.dart';
import 'package:stg_flutter/views/discover_page/components/filter_component/state.dart';

import 'components/movicecell_component/state.dart';

class DiscoverPageState extends MutableSource
    implements GlobalBaseState, Cloneable<DiscoverPageState> {
  List<SortCondition> sortType;
  List<String> filterTabNames;
  FilterState filterState;
  VideoListModel videoListModel;
  String selectedSort;
  ScrollController scrollController;
  GlobalKey stackKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  GZXDropdownMenuController dropdownMenuController;
  bool isbusy;
  @override
  DiscoverPageState clone() {
    return DiscoverPageState()
      ..sortType = sortType
      ..filterTabNames = filterTabNames
      ..filterState = filterState
      ..videoListModel = videoListModel
      ..selectedSort = selectedSort
      ..scrollController = scrollController
      ..dropdownMenuController = dropdownMenuController
      ..scaffoldKey = scaffoldKey
      ..stackKey = stackKey
      ..isbusy = isbusy;
  }

  @override
  Color themeColor;

  @override
  Locale locale;

  @override
  FirebaseUser user;

  @override
  Object getItemData(int index) => VideoCellState()
    ..videodata = videoListModel?.results[index]
    ..isMovie = filterState?.isMovie ?? true;

  @override
  String getItemType(int index) => 'moviecell';

  @override
  int get itemCount => videoListModel?.results?.length ?? 0;

  @override
  void setItemData(int index, Object data) {}
}

DiscoverPageState initState(Map<String, dynamic> args) {
  final DiscoverPageState state = DiscoverPageState();
  state.filterTabNames = new List<String>()..add('Sort By')..add('Filter');
  state.filterState = new FilterState();
  state.scaffoldKey = GlobalKey();
  state.stackKey = GlobalKey();
  state.isbusy = false;
  state.dropdownMenuController = GZXDropdownMenuController();
  state.videoListModel =
      new VideoListModel.fromParams(results: List<VideoListResult>());
  state.sortType = new List<SortCondition>()
    ..add(SortCondition(
        name: 'Popularity Descending',
        isSelected: false,
        value: DiscoverSortType.populartiyDesc))
    ..add(SortCondition(
        name: 'Popularity Ascending',
        isSelected: false,
        value: DiscoverSortType.populartiyAsc))
    ..add(SortCondition(
        name: 'Rating Descending',
        isSelected: false,
        value: DiscoverSortType.voteAverageDesc))
    ..add(SortCondition(
        name: 'Rating Ascending',
        isSelected: false,
        value: DiscoverSortType.voteAverageDesc))
    ..add(SortCondition(
        name: 'Release Date Descending',
        isSelected: false,
        value: DiscoverSortType.releaseDateDesc))
    ..add(SortCondition(
        name: 'Release Date Ascending',
        isSelected: false,
        value: DiscoverSortType.releaseDateAsc))
    ..add(SortCondition(
        name: 'Title (A-Z)',
        isSelected: false,
        value: DiscoverSortType.originalTitleAsc))
    ..add(SortCondition(
        name: 'Title (Z-A)',
        isSelected: false,
        value: DiscoverSortType.originalTitleDesc));
  return state;
}
