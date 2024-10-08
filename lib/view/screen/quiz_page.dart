import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cri_pat_5/api/models.dart';
import 'package:cri_pat_5/constants/color.dart';
import 'package:cri_pat_5/constants/theme.dart';
import 'package:cri_pat_5/view/screen/quiz_result.dart';
import 'package:cri_pat_5/view/style/screen/base_titled.dart';
import 'package:cri_pat_5/view/widget/button/rounded_button.dart';
import 'package:cri_pat_5/view/widget/dialog/popup_dialog_widget.dart';
import 'package:cri_pat_5/widgets/quiz_question.dart';
import 'package:cri_pat_5/widgets/title/titlebar.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class QuizPage extends StatefulWidget {
  QuizPage(this.topic, this.quiz, {Key? key})
      // We need to generate a *unique* map for each question answer (List.fill would reuse the same map)
      : selectedAnswers = List.generate(quiz.questions.length, (_) => {}),
        super(key: key);

  final Topic topic;
  final GeneratedQuiz quiz;

  // At list index 0, all answer selections for question 0 are saved.
  // The map<int, bool> maps the answer id to a selection (boolean).
  final List<Map<int, bool>> selectedAnswers;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  PageView _questionView() {
    return PageView.builder(
      itemCount: widget.quiz.questions.length,
      controller: _pageController,
      itemBuilder: (BuildContext context, int index) {
        return QuizQuestionWidget(
          widget.quiz.questions[index],
          widget.selectedAnswers[index],
        );
      },
      onPageChanged: (int index) {
        _currentPageNotifier.value = index;
      },
    );
  }

  Widget _dotIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CirclePageIndicator(
        size: 24,
        selectedSize: 24,
        onPageSelected: (i) {
          if (_currentPageNotifier.value != i) {
            _pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        itemCount: widget.quiz.questions.length,
        currentPageNotifier: _currentPageNotifier,
        dotColor: MQColor.primaryColor,
        selectedDotColor: MQColor.secondaryColor,
        dotSpacing: 2,
      ),
    );
  }

  Future<bool> _yesNoDialog(
    BuildContext dialogContext, {
    String? title,
    String? content,
    String? yesText,
  }) async {
    bool result = true;
    await showDialog(
      context: dialogContext,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: PopupDialogWidget(
            title: title ?? "",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(content != null) Padding(
                  padding: EdgeInsets.only(
                    bottom: 18.0,
                    left: MQTheme.cardPaddingBigV,
                    right: MQTheme.cardPaddingBigV,
                  ),
                  child: Text(
                    content,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                      text: yesText ?? AppLocalizations.of(context)!.yes,
                      onClick: () {
                        result = true;
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 12,),
                    RoundedButton(
                      text: AppLocalizations.of(context)!.no,
                      onClick: () {
                        result = false;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            )
          )
        );
      },
    );
    return result;
  }

  // Ask the user before leaving the quiz if they are sure
  Future<bool> _beforeQuizLeave(BuildContext context) async {
    return _yesNoDialog(
      context,
      title: AppLocalizations.of(context)!.cancelQuiz,
      content: AppLocalizations.of(context)!.cancelQuizDescription,
      yesText: AppLocalizations.of(context)!.yes,
    );
  }

  Future<void> _quizSubmit(BuildContext context) async {
    var unansweredQuestionsCount = widget.selectedAnswers
        .map(
          (q) => q.containsValue(true),
        )
        .fold(
          0,
          (int prev, bool answered) => prev + (answered ? 0 : 1),
        );

    var shouldSubmit = false;

    // Depending on how many questions were left unanswered, we show different dialogs
    switch (unansweredQuestionsCount) {
      case 0:
        shouldSubmit = await _yesNoDialog(
          context,
          title: AppLocalizations.of(context)!.endQuizDialogTitle,
          content: AppLocalizations.of(context)!.endQuizDialogContent,
        );
        break;
      case 1:
        shouldSubmit = await _yesNoDialog(
          context,
          title: AppLocalizations.of(context)!.endQuizDialogTitle,
          content: AppLocalizations.of(context)!.endQuizOneQuestionMissing,
        );
        break;
      default:
        shouldSubmit = await _yesNoDialog(
          context,
          title: AppLocalizations.of(context)!.endQuizDialogTitle,
          content: AppLocalizations.of(context)!
              .endQuizQuestionsMissing(unansweredQuestionsCount),
        );
        break;
    }
    if (!shouldSubmit) {
      return;
    }

    List<QuizSubmission> submissions = [];

    for (var i = 0; i < widget.quiz.questions.length; i++) {
      submissions.add(QuizSubmission(
        questionId: widget.quiz.questions[i].id,
        chosenAnswerIds: widget.selectedAnswers[i].entries
            .where((answer) => answer.value)
            .map((a) => a.key)
            .toList(),
      ));
    }

    await Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => QuizResultPage(widget.quiz, submissions),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenTitled(
      titleBar: BasicTitleBar(
        title: (widget.quiz.topic ?? widget.topic).title,
      ),
      child: WillPopScope(
        onWillPop: () => _beforeQuizLeave(context),
        child: Column(
          children: [
            Expanded(
              child: _questionView(),
            ),
            _dotIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: RoundedButton(
                onClick: () => _quizSubmit(context),
                text: AppLocalizations.of(context)!.endQuiz,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
