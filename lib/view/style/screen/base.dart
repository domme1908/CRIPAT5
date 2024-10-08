
import 'package:flutter/material.dart';
import 'package:cri_pat_5/constants/color.dart';
import 'package:cri_pat_5/controller/screen_size.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({
    this.child = const SizedBox(),
    Future<bool> Function()? clickBack,
    Key? key
  }) : super(key: key ?? UniqueKey()) {
    this.clickBack = clickBack ?? () async {
      return true;
    };
  }

  Widget child;
  late Future<bool> Function() clickBack;

  @override
  _BaseScreenState createState() => _BaseScreenState(child: child);
}

class _BaseScreenState extends State<BaseScreen> {
  _BaseScreenState({this.child = const SizedBox()});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.clickBack,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MQColor.bgColorLight,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, cstr) {
              return ChangeNotifierProvider<ScreenSize>.value(
                value: ScreenSize(
                  minWidth: cstr.minWidth,
                  maxWidth: cstr.maxWidth,
                  minHeight: cstr.minHeight,
                  maxHeight: cstr.maxHeight,
                ),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

