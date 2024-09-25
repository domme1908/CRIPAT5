import 'package:flutter/material.dart';
import 'package:cri_pat_5/view/style/screen/base.dart';


class InitScreen extends StatefulWidget {
  InitScreen({Key? key}) : super(key: key ?? UniqueKey());

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        child: const Center(
          child: CircularProgressIndicator(),
        )
    );
  }
}
