import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/views/seasondetail_page/components/episodes_component/component.dart';
import 'package:stg_flutter/views/seasondetail_page/components/seasoncast_component/component.dart';
import 'package:stg_flutter/views/seasondetail_page/components/seasoncrew_component/component.dart';

import 'components/header_component/component.dart';
import 'state.dart';

class SeasonDetailAdapter extends SourceFlowAdapter<SeasonDetailPageState> {
  SeasonDetailAdapter()
      : super(
          pool: <String, Component<Object>>{
            'header': HeaderComponent(),
            'seasonCast': SeasonCastComponent(),
            'seasonCrew': SeasonCrewComponent(),
            'episodes': EpisodesComponent()
          },
        );
}
