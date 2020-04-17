import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/searchresult.dart';

class TrendingCellState implements Cloneable<TrendingCellState> {
  SearchResult cellData;
  int index;
  TrendingCellState({this.cellData, this.index});
  @override
  TrendingCellState clone() {
    return TrendingCellState();
  }
}

TrendingCellState initState(Map<String, dynamic> args) {
  return TrendingCellState();
}
