import 'package:flutter/material.dart';
import 'package:munich_data_quiz/api/models.dart';
import 'package:munich_data_quiz/api/quiz_api.dart';
import 'package:munich_data_quiz/constants/color.dart';
import 'package:munich_data_quiz/constants/theme.dart';
import 'package:munich_data_quiz/view/screen/topic_details.dart';
import 'package:munich_data_quiz/view/widget/card/notification_single_line_card.dart';
import 'package:munich_data_quiz/widgets/topic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopicListPage extends StatefulWidget {
  const TopicListPage({Key? key}) : super(key: key);

  @override
  _TopicListPageState createState() => _TopicListPageState();
}

// TODO check if pull up to load new works
class _TopicListPageState extends State<TopicListPage> {
  bool loading = true, firstBuild = true;
  List<Topic> topics = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String _error = "";

  Future<void> rebuildCommunityList() async {
    setLoading();
    topics.clear();

    topics.add(Topic.random(context));

    var topicsRaw = await QuizAPI().topics().onError((error, stackTrace) {
      _error = error.toString();
      return [];
    });

    for (Topic newTopicsRaw in topicsRaw) {
      var find = topics.where((element) => element.id == newTopicsRaw.id);
      if (find.isEmpty) {
        // topic not yet present
        topics.add(newTopicsRaw);
      }
    }
    setLoading(l: false);
  }

  void setLoading({bool l = true}) {
    setState(() {
      loading = l;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    rebuildCommunityList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      rebuildCommunityList();
      firstBuild = false;
    }

    Widget comList;

    if (loading) {
      comList = const Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(18.0),
            child: CircularProgressIndicator(),
          )
        ],
      );
    } else {
      if (topics.isEmpty) {
        comList = Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 34, horizontal: MQTheme.screenPaddingH),
          child: Column(
            children: [
              InfoCard(
                cardColor: MQColor.primaryColor,
                text: AppLocalizations.of(context)!.noTopicsFound,
              ),
            ],
          ),
        );
      } else {
        comList = ListView.builder(
          itemBuilder: (c, i) => TopicWidget(
            topic: topics[i],
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TopicPage(topics[i]),
              ));
            },
          ),
          itemCount: topics.length,
          physics: const BouncingScrollPhysics(),
          cacheExtent: MediaQuery.of(context).size.height * 2,
        );
      }
    }

    return Column(
      children: [
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const MaterialClassicHeader(), // WaterDropHeader
            footer: const ClassicFooter(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: comList,
          ),
        ),
      ],
    );
  }
}
