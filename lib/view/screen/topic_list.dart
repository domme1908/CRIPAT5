import 'package:flutter/material.dart';
import 'package:munich_data_quiz/api/models.dart';
import 'package:munich_data_quiz/api/quiz_api.dart';
import 'package:munich_data_quiz/constants/color.dart';
import 'package:munich_data_quiz/constants/theme.dart';
import 'package:munich_data_quiz/view/screen/topic_details.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/card/notification_single_line_card.dart';

class TopicListPage extends StatefulWidget {
  const TopicListPage({Key? key}) : super(key: key);

  @override
  _TopicListPageState createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  bool loading = true, firstBuild = true;
  List<Topic> topics = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String _error = "";

  Future<void> rebuildCommunityList() async {
    setLoading();
    topics.clear();

    // Add random topic first with image
    topics.add(Topic.random(context));

    // Fetch all topics from API (this assumes your QuizAPI returns topics)
    var topicsRaw = await QuizAPI().topics().onError((error, stackTrace) {
      _error = error.toString();
      print(error);
      return [];
    });
    print(topicsRaw.length); 

    for (Topic newTopicsRaw in topicsRaw) {
      var find = topics.where((element) => element.id == newTopicsRaw.id);
      if (find.isEmpty) {
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
          itemCount: topics.length,
          itemBuilder: (context, index) {
            // Keep the first element (random topic) with an image
            if (index == 0) {
              return _buildRandomTopic(topics[index]);
            } else {
              // Compact list without image for other topics
              return _buildCompactTopic(topics[index]);
            }
          },
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
            header: const MaterialClassicHeader(),
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

  // Method to build the random topic item with an image
  Widget _buildRandomTopic(Topic topic) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TopicPage(topic),
        ));
      },
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Image for the random topic
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  topic.imageUrl ?? "assets/default_topic_image.png",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.description ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build compact topic items without images
  Widget _buildCompactTopic(Topic topic) {
    return ListTile(
      title: Text(
        topic.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TopicPage(topic),
        ));
      },
    );
  }
}
