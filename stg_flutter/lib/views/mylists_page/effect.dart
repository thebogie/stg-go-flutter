import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:stg_flutter/actions/base_api.dart';
import 'package:stg_flutter/customwidgets/custom_stfstate.dart';
import 'action.dart';
import 'state.dart';

Effect<MyListsPageState> buildEffect() {
  return combineEffects(<Object, Effect<MyListsPageState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.deactivate: _onDeactivate,
    Lifecycle.dispose: _onDispose,
    MyListsPageAction.createList: _createList,
  });
}

Future _onInit(Action action, Context<MyListsPageState> ctx) async {
  final ticker = ctx.stfState as CustomstfState;
  ctx.state.animationController =
      AnimationController(vsync: ticker, duration: Duration(milliseconds: 300));
  ctx.state.cellAnimationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 1000));
  ctx.state.scrollController = ScrollController(keepScrollOffset: false);
  if (ctx.state.user != null) {
    final data = await BaseApi.getUserList(ctx.state.user.uid);
    ctx.dispatch(MyListsPageActionCreator.setList(data));
  }
}

void _onDispose(Action action, Context<MyListsPageState> ctx) {
  ctx.state.cellAnimationController.stop();
  ctx.state.scrollController.dispose();
  ctx.state.animationController.dispose();
  ctx.state.cellAnimationController.dispose();
}

void _onDeactivate(Action action, Context<MyListsPageState> ctx) {
  ctx.state.cellAnimationController.stop();
  ctx.state.animationController.stop();
}

void _createList(Action action, Context<MyListsPageState> ctx) async {
  ctx.state.animationController.value = 0;
  ctx.dispatch(MyListsPageActionCreator.onEdit(false));
  await Navigator.of(ctx.context)
      .pushNamed('createListPage', arguments: action.payload)
      .then((d) {
    if (d != null) {
      ctx.state.listData.data.insert(0, d);
      ctx.dispatch(MyListsPageActionCreator.setList(ctx.state.listData));
    }
  });
}
