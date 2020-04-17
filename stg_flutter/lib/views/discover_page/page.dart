import 'package:fish_redux/fish_redux.dart';
import 'package:stg_flutter/views/discover_page/components/filter_component/component.dart';

import 'adapter.dart';
import 'components/filter_component/state.dart' as filter;
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DiscoverPage extends Page<DiscoverPageState, Map<String, dynamic>> {
  DiscoverPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DiscoverPageState>(
              adapter: NoneConn<DiscoverPageState>() + DiscoverListAdapter(),
              slots: <String, Dependent<DiscoverPageState>>{
                'filter': filter.FilterConnector() + FilterComponent()
              }),
          middleware: <Middleware<DiscoverPageState>>[],
        );
}
