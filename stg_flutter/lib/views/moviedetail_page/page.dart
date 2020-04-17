import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/customwidgets/custom_stfstate.dart';
import 'package:stg_flutter/views/moviedetail_page/components/info_component/component.dart';
import 'package:stg_flutter/views/moviedetail_page/components/keywords_component/component.dart';
import 'package:stg_flutter/views/moviedetail_page/components/keywords_component/state.dart';

import 'components/info_component/state.dart';
import 'components/menu_component/component.dart';
import 'components/menu_component/state.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MovieDetailPage extends Page<MovieDetailPageState, Map<String, dynamic>> {
   @override
  CustomstfState<MovieDetailPageState> createState()=>CustomstfState<MovieDetailPageState> ();
  MovieDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MovieDetailPageState>(
                adapter: null,
                slots: <String, Dependent<MovieDetailPageState>>{
                  'keywords':KeyWordsConnector()+KeyWordsComponent(),
                  'info':InfoConnector()+InfoComponent(),
                  'menu':MenuConnector()+MenuComponent()
                }),
            middleware: <Middleware<MovieDetailPageState>>[
            ],);
}
