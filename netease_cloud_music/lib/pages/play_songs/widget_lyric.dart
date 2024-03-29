import 'dart:ui';
import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/model/lyric.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';

class LyricWidget extends CustomPainter with ChangeNotifier {
  List<Lyric> lyric;
  List<TextPainter> lyricPaints = []; // 其他歌词
  double _offsetY = 0;
  int curLine;

  get offsetY => _offsetY;

  set offsetY(double value) {
    _offsetY = value;
    notifyListeners();
  }

  LyricWidget(this.lyric, this.curLine) {
    lyricPaints.addAll(lyric
        .map((l) => TextPainter(
            text: TextSpan(text: l.lyric, style: commonGrayTextStyle),
            textDirection: TextDirection.ltr))
        .toList());
    // 首先对TextPainter 进行 layout，否则会报错
    _layoutTextPainters();
  }

  @override
  void paint(Canvas canvas, Size size) {
    var y = _offsetY + size.height / 2 + lyricPaints[0].height / 2;
    for (int i = 0; i < lyric.length; i++) {
      if (y > size.height || y < (0 - lyricPaints[i].height / 2)) {
      } else {
        // 画每一行歌词
        if (curLine == i) {
          lyricPaints[i].text =
              TextSpan(text: lyric[i].lyric, style: commonWhiteTextStyle);
          lyricPaints[i].layout();
        } else {
          lyricPaints[i].text =
              TextSpan(text: lyric[i].lyric, style: commonGrayTextStyle);
          lyricPaints[i].layout();
        }
        lyricPaints[i].paint(
          canvas,
          Offset((size.width - lyricPaints[i].width) / 2, y),
        );
      }
      // 计算偏移量
      y += lyricPaints[i].height + ScreenUtil().setWidth(30);
    }
  }

  /// 计算传入行和第一行的偏移量
  double computeScrollY(int curLine){
    return (lyricPaints[0].height + ScreenUtil().setWidth(30)) * (curLine + 1);
  }

  void _layoutTextPainters() {
    lyricPaints.forEach((lp) => lp.layout());
  }

  @override
  bool shouldRepaint(LyricWidget oldDelegate) {
    return oldDelegate._offsetY != _offsetY;
  }
}
