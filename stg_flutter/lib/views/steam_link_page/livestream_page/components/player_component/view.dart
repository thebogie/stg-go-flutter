import 'package:chewie/chewie.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stg_flutter/actions/adapt.dart';
import 'package:stg_flutter/customwidgets/sliverappbar_delegate.dart';
import 'package:stg_flutter/customwidgets/web_torrent_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as youtube;

import 'state.dart';

Widget buildView(
    PlayerState state, Dispatch dispatch, ViewService viewService) {
  final double _height = Adapt.screenW() * 9 / 16;
  return SliverPersistentHeader(
    pinned: true,
    delegate: SliverAppBarDelegate(
        maxHeight: _height + Adapt.padTopH(),
        minHeight: _height + Adapt.padTopH(),
        child: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                height: Adapt.padTopH(),
              ),
              _Player(
                streamAddress: state.streamAddress,
                streamLinkTypeName: state.streamLinkTypeName,
                youtubePlayerController: state.youtubePlayerController,
                chewieController: state.chewieController,
              )
            ],
          ),
        )),
  );
}

class _Player extends StatelessWidget {
  final String streamLinkTypeName;
  final String streamAddress;
  final ChewieController chewieController;
  final youtube.YoutubePlayerController youtubePlayerController;
  const _Player(
      {this.chewieController,
      this.streamAddress,
      this.streamLinkTypeName,
      this.youtubePlayerController});
  @override
  Widget build(BuildContext context) {
    final double _height = Adapt.screenW() * 9 / 16;
    String key = streamLinkTypeName ?? '';
    switch (key) {
      case 'YouTube':
        return youtube.YoutubePlayer(
          controller: youtubePlayerController,
          topActions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: Adapt.px(80),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
          progressIndicatorColor: Colors.red,
          progressColors: youtube.ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        );
      case 'WebView':
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: InAppWebView(
              key: ValueKey(streamAddress),
              initialUrl: streamAddress,
              initialHeaders: {},
              initialOptions: InAppWebViewWidgetOptions(
                  crossPlatform: InAppWebViewOptions(
                debuggingEnabled: true,
              ))),
        );
      case 'other':
        return Container(
          color: Colors.black,
          alignment: Alignment.bottomCenter,
          height: _height,
          child: chewieController != null
              ? Chewie(
                  key: ValueKey(chewieController), controller: chewieController)
              : SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
        );
      case 'Torrent':
        return WebTorrentPlayer(
          key: ValueKey(streamAddress),
          url: streamAddress,
        );
      default:
        return Container(
          height: _height,
          color: Colors.black,
        );
    }
  }
}
