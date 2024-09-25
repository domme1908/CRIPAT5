import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cri_pat_5/api/models.dart';
import 'package:cri_pat_5/api/quiz_api.dart';
import 'package:cri_pat_5/constants/color.dart';
import 'package:cri_pat_5/constants/theme.dart';
import 'package:cri_pat_5/model/dummy/dummy_numbers.dart';
import 'package:cri_pat_5/view/screen/quiz_page.dart';
import 'package:cri_pat_5/view/style/screen/base_titled.dart';
import 'package:cri_pat_5/view/widget/button/rounded_button.dart';
import 'package:cri_pat_5/view/widget/dialog/popup_dialog_widget.dart';
import 'package:cri_pat_5/widgets/image_widget.dart';
import 'package:cri_pat_5/widgets/title/titlebar.dart';
import 'package:loading_btn/loading_btn.dart'; // Updated import

class TopicPage extends StatefulWidget {
  const TopicPage(this.topic, {Key? key}) : super(key: key);

  final Topic topic;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScreenTitled(
      titleBar: BasicTitleBar(title: widget.topic.title),
      child: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: MQTheme.screenPaddingH),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(MQTheme.radiusCard),
                child: ImageWidget(
                  widget.topic.imageUrl,
                  heroTag: "topic-image",
                  id: "${widget.topic.id}",
                ),
              ),
              SizedBox(height: MQTheme.cardPaddingBigV),
              Text(
                widget.topic.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.topic.description != null)
                Container(
                  padding: const EdgeInsets.only(top: 4),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    widget.topic.description!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: MQTheme.cardPaddingBigV),
              LoadingBtn(
                height: 50,
                borderRadius: 8,
                roundLoadingShape: false,
                color: MQColor.primaryColor,
                width: MediaQuery.of(context).size.width * 0.45,
                minWidth: MediaQuery.of(context).size.width * 0.30,
                loader: const Text("Loading..."),
                child: Text(
                  AppLocalizations.of(context)!.startQuiz,
                  style: const TextStyle(
                    color: MQColor.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: (startLoading, stopLoading, btnState) async {
                  if (btnState == ButtonState.idle) {
                    startLoading();
                    try {
                      // If the topic ID is -1, load a random topic
                      int topicId = widget.topic.id;
                      if (topicId == -1) {
                        final String jsonString = await rootBundle
                            .loadString('assets/questions.json');
                        final List<dynamic> jsonData = jsonDecode(jsonString);

                        // Convert the JSON data into a list of Topic objects
                        List<Topic> topics = jsonData
                            .map((topicData) => Topic.fromJson(topicData))
                            .toList();
                        topicId = Random().nextInt(topics.length) + 1;

                      }
                      // Generate the quiz with the valid or random topic ID
                      var quiz = await QuizAPI().generateQuiz(
                        topicId, // Use the fetched random topic ID or the original topic ID
                        30,
                      );

                      // Navigate to the quiz page
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QuizPage(widget.topic, quiz),
                      ));
                    } catch (err) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return PopupDialogWidget(
                            title: AppLocalizations.of(context)!.error,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 18.0,
                                    left: MQTheme.cardPaddingBigV,
                                    right: MQTheme.cardPaddingBigV,
                                  ),
                                  child: Text(
                                    "$err",
                                    maxLines: 4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RoundedButton(
                                      text: AppLocalizations.of(context)!
                                          .okayGotIt,
                                      onClick: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } finally {
                      stopLoading();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
