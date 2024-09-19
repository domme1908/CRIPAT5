
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:munich_data_quiz/constants/color.dart';
import 'package:munich_data_quiz/view/widget/button/colored_icon_button.dart';
import 'package:munich_data_quiz/widgets/title/titles.dart';
import 'package:munich_data_quiz/widgets/title/titletext.dart';
import 'package:url_launcher/url_launcher.dart';

class TitleBarWidget extends StatelessWidget {
  TitleBarWidget({
    this.customTitle,
    this.subtitle = "",
    this.subtitleIcon,
    this.enableButton = false,
    this.buttonColor,
    this.buttonIcon = Icons.inbox,
    this.buttonCounter = 0,
    VoidCallback? buttonOnClick,
    Key? key,
  }) : super(key: key) {
    this.buttonOnClick = buttonOnClick ?? (){};
  }

  String? customTitle;
  String subtitle;
  bool enableButton;
  Color? buttonColor;
  IconData? subtitleIcon;
  IconData buttonIcon;
  int? buttonCounter;
  late VoidCallback? buttonOnClick;

  void clickBackButton(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = const SizedBox(width: 0);
    if (buttonCounter != 0) {
      button = const Positioned(
        right: 0,
        child: CircleAvatar(
          backgroundColor: Color.fromARGB(255, 235, 150, 150),
          radius: 10,
          child: Text("12", style:
          TextStyle(fontSize: 9, fontWeight: FontWeight.bold,
              color: Colors.white),),
        ),
      );
    }

    Widget backButton = const SizedBox(width: 0,);
    if (Navigator.of(context).canPop()) {
      backButton = Padding(
        padding: const EdgeInsets.only(right: 4, top: 2),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.transparent,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            splashRadius: 20,
            icon: const Icon(
              Icons.keyboard_backspace,
              color: MQColor.textColor,
            ),
            onPressed: () => clickBackButton(context),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: Navigator.of(context).canPop() ? 20 : 32,
          top: 12, bottom: 12, right: 32),
      color: MQColor.bgColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              backButton,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  LogoTitle(scale: 0.8, customTitle: customTitle,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0, left: 12),
                    child: SubTitleWidget(title: subtitle, scale: 0.8),
                  ),
                  const SizedBox(width: 6,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Icon(
                      subtitleIcon,
                      color: MQColor.primaryColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 46,
            child: enableButton ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4, top: 2),
                  child: ColoredIconButton(
                    onClick: buttonOnClick ?? (){},
                    icon: buttonIcon,
                  ),
                ),
                button,
              ],
            ) : const SizedBox(width: 0,),
          ),
        ],
      ),
    );
  }
}

class DefaultTitleBar extends StatelessWidget {
  const DefaultTitleBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TitleBarWidget(
      
      subtitle: "CRI Tradate",
    );
  }
}

class BasicTitleBar extends StatelessWidget {
  BasicTitleBar({
    this.title = "",
    Key? key}) : super(key: key);

  String title;

  @override
  Widget build(BuildContext context) {
    return TitleBarWidget(
      customTitle: title,
    );
  }
}
