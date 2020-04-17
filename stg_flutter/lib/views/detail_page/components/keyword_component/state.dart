import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/keyword.dart';
import 'package:stg_flutter/views/detail_page/state.dart';

class KeyWordState implements Cloneable<KeyWordState> {
  List<KeyWordData> keyWords;
  @override
  KeyWordState clone() {
    return KeyWordState();
  }
}

class KeyWordConnector extends ConnOp<MovieDetailPageState, KeyWordState> {
  @override
  KeyWordState get(MovieDetailPageState state) {
    KeyWordState substate = new KeyWordState();
    substate.keyWords = state.detail?.keywords?.keywords ?? [];
    return substate;
  }
}
