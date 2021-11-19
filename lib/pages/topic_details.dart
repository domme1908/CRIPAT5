import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:munich_data_quiz/api/models.dart';
import 'package:munich_data_quiz/widgets/image_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class TopicPage extends StatefulWidget {
  const TopicPage(this.topic, {Key? key}) : super(key: key);

  final Topic topic;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final _btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
      ),
      body: Center(
        child: Column(
          children: [
            ImageWidget(
              widget.topic.imageUrl,
              heroTag: "topic-image",
              id: widget.topic.topicId,
            ),
            const Divider(),
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
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(
                  widget.topic.description!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            const Divider(),
            RoundedLoadingButton(
              controller: _btnController,
              onPressed: () async {
                // TODO: Load data
                await Future.delayed(const Duration(seconds: 2));

                try {
                  _btnController.success();
                } catch (_) {}

                await Future.delayed(
                  const Duration(seconds: 2),
                  () => _btnController.reset(),
                );
              },
              child: Text(AppLocalizations.of(context)!.startQuiz),
            ),
          ],
        ),
      ),
    );
  }
}
