import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:stg_flutter/actions/adapt.dart';
import 'package:stg_flutter/models/sortcondition.dart';
import 'package:stg_flutter/style/themestyle.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    FliterState state, Dispatch dispatch, ViewService viewService) {
  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);

  final TextStyle _selectTS =
      TextStyle(fontWeight: FontWeight.bold, fontSize: Adapt.px(30));

  final TextStyle _unSelectTS = TextStyle(fontSize: Adapt.px(30));

  PopupMenuItem<SortCondition> _buildCell(SortCondition<dynamic> s) {
    final unSelectedStyle = TextStyle(color: Colors.grey);
    final selectedStyle = TextStyle(fontWeight: FontWeight.bold);
    return PopupMenuItem<SortCondition>(
      value: s,
      child: Row(
        children: <Widget>[
          Text(
            s.name,
            style: s.isSelected ? selectedStyle : unSelectedStyle,
          ),
          Expanded(
            child: Container(),
          ),
          s.isSelected ? Icon(Icons.check) : SizedBox()
        ],
      ),
    );
  }

  return SliverToBoxAdapter(
    child: AnimatedBuilder(
      animation: state.animationController,
      builder: (_, __) {
        return Container(
          width: Adapt.px(300),
          height: Tween<double>(begin: 0.0, end: Adapt.px(80))
              .animate(CurvedAnimation(
                parent: state.animationController,
                curve: Curves.ease,
              ))
              .value,
          color: _theme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () => dispatch(FliterActionCreator.dateChanged(true)),
                child: Text('Today',
                    style: state.isToday ? _selectTS : _unSelectTS),
              ),
              SizedBox(
                width: Adapt.px(50),
              ),
              InkWell(
                  onTap: () => dispatch(FliterActionCreator.dateChanged(false)),
                  child: Text(
                    'This Week',
                    style: state.isToday ? _unSelectTS : _selectTS,
                  )),
              Expanded(
                child: SizedBox(),
              ),
              FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: state.animationController,
                    curve: Interval(0.5, 1, curve: Curves.ease))),
                child: PopupMenuButton<SortCondition>(
                  padding: EdgeInsets.zero,
                  offset: Offset(0, Adapt.px(100)),
                  icon: Icon(Icons.apps),
                  onSelected: (selected) =>
                      dispatch(FliterActionCreator.mediaTypeChanged(selected)),
                  itemBuilder: (ctx) {
                    return state.mediaTypes.map(_buildCell).toList();
                  },
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}
