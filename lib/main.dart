import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cri_pat_5/constants/color.dart';
import 'package:cri_pat_5/setup.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: MQColor.bgColorLight,
    systemNavigationBarIconBrightness: MQColor.systemNavBarBrightness,
    statusBarColor: MQColor.bgColorLight,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SetupSequence();
  }
}
