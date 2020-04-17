import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/creditsmodel.dart';

class SeasonCastState implements Cloneable<SeasonCastState> {

  List<CastData> castData;
  int showcount;

  SeasonCastState({this.castData,this.showcount=6});

  @override
  SeasonCastState clone() {
    return SeasonCastState()
    ..castData=castData
    ..showcount=showcount;
  }
}

SeasonCastState initState(Map<String, dynamic> args) {
  return SeasonCastState();
}
