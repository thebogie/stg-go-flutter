import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/models/combinedcredits.dart';
import 'package:stg_flutter/models/enums/media_type.dart';
import 'package:stg_flutter/models/peopledetail.dart';

enum PeopleDetailPageAction {
  action,
  init,
  setCreditModel,
  showBiography,
  cellTapped
}

class PeopleDetailPageActionCreator {
  static Action onAction() {
    return const Action(PeopleDetailPageAction.action);
  }

  static Action onInit(PeopleDetailModel p) {
    return Action(PeopleDetailPageAction.init, payload: p);
  }

  static Action onSetCreditModel(CombinedCreditsModel p, List<CastData> cast) {
    return Action(PeopleDetailPageAction.setCreditModel, payload: [p, cast]);
  }

  static Action onShowBiography() {
    return Action(PeopleDetailPageAction.showBiography);
  }

  static Action onCellTapped(
      int id, String bgpic, String name, String poster, MediaType type) {
    return Action(PeopleDetailPageAction.cellTapped,
        payload: [id, bgpic, name, poster, type]);
  }
}
