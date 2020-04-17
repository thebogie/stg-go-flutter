import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/imagemodel.dart';
import 'package:stg_flutter/views/detail_page/state.dart';

class StillState implements Cloneable<StillState> {
  ImageModel imagesmodel;
  @override
  StillState clone() {
    return StillState();
  }
}

class StillConnector extends ConnOp<MovieDetailPageState, StillState> {
  @override
  StillState get(MovieDetailPageState state) {
    StillState substate = new StillState();
    substate.imagesmodel = state.imagesmodel;
    return substate;
  }
}