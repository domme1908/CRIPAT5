
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cri_pat_5/view/screen/topic_list.dart';
import 'package:cri_pat_5/view/style/screen/base_titled.dart';
import 'package:cri_pat_5/widgets/title/titlebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return BaseScreenTitled(
      titleBar: const DefaultTitleBar(),
      child: const TopicListPage(),
    );
  }

}
