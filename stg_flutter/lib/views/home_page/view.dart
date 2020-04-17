import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:stg_flutter/actions/adapt.dart';
import 'package:stg_flutter/customwidgets/backdrop.dart';
import 'package:stg_flutter/generated/i18n.dart';
import 'package:stg_flutter/style/themestyle.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    HomePageState state, Dispatch dispatch, ViewService viewService) {
  return Builder(
    builder: (context) {
      final ThemeData _theme = ThemeStyle.getTheme(context);
      return Scaffold(
          appBar: AppBar(
            backgroundColor: _theme.bottomAppBarColor,
            brightness: Brightness.dark,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: _SearchBar(
              onTap: () => dispatch(HomePageActionCreator.onSearchBarTapped()),
            ),
          ),
          body: BackDrop(
            height: Adapt.px(520),
            backChild: viewService.buildComponent('header'),
            frontBackGroundColor: _theme.backgroundColor,
            frontChild: Container(
              color: _theme.backgroundColor,
              child: ListView(
                dragStartBehavior: DragStartBehavior.down,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  viewService.buildComponent('swiper'),
                  viewService.buildComponent('trending'),
                  viewService.buildComponent('share'),
                  viewService.buildComponent('popularposter'),
                ],
              ),
            ),
          ));
    },
  );
}

class _SearchBar extends StatelessWidget {
  final Function onTap;
  const _SearchBar({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.only(left: Adapt.px(30), right: Adapt.px(30)),
          height: Adapt.px(70),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Adapt.px(40)),
            color: Color.fromRGBO(57, 57, 57, 1),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.grey,
              ),
              SizedBox(
                width: Adapt.px(20),
              ),
              Text(
                I18n.of(context).searchbartxt,
                style: TextStyle(color: Colors.grey, fontSize: Adapt.px(28)),
              )
            ],
          )),
    );
  }
}
