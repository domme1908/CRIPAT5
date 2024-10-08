import 'package:flutter/cupertino.dart';
import 'package:cri_pat_5/constants/text.dart';
import 'package:cri_pat_5/widgets/title/titles.dart';

class LogoTitle extends StatelessWidget {
  LogoTitle({
    this.scale = 1.0,
    this.customTitle,
    Key? key
  }) : super(key: key);

  double scale;
  String? customTitle;

  @override
  Widget build(BuildContext context) {
    return TitleH1Widget(
      scale: scale,
      title: customTitle ?? MQTexts.appName,
    );
  }
}
