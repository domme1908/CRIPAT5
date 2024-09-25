import 'package:flutter/material.dart';
import 'package:cri_pat_5/api/models.dart';
import 'package:cri_pat_5/api/quiz_api.dart';
import 'package:cri_pat_5/constants/color.dart';
import 'package:cri_pat_5/constants/theme.dart';
import 'package:cri_pat_5/controller/screen_size.dart';
import 'package:cri_pat_5/view/style/screen/base_titled.dart';
import 'package:cri_pat_5/widgets/image_widget.dart';
import 'package:cri_pat_5/widgets/title/titlebar.dart';
import 'package:provider/provider.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage(this.quiz, this.submission, {Key? key})
      : super(key: key);

  final GeneratedQuiz quiz;
  final List<QuizSubmission> submission;

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  static const titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // Calculate the number of correct answers
  int _calculateCorrectAnswers(List<EvaluatedQuestion> evaluatedQuestions) {
    return evaluatedQuestions
        .where((question) => question.answerCorrect == true)
        .length;
  }

  // Calculate the number of mistakes
  int _calculateMistakes(List<EvaluatedQuestion> evaluatedQuestions) {
    return evaluatedQuestions.length -
        _calculateCorrectAnswers(evaluatedQuestions);
  }

  // Determine if the user passed or failed
  String _getResultMessage(int mistakes) {
    return mistakes <= 8 ? 'Passato' : 'Bocciato';
  }

  Widget _answer(
      BuildContext context, QuizAnswer answer, EvaluatedQuestion result) {
    QuizSubmission submitted = widget.submission
        .firstWhere((question) => question.questionId == result.questionId);

    bool answerIncorrect = result.incorrectAnswers
            ?.any((incorrect) => answer.id == incorrect.id) ??
        false;

    bool selectedByUser = submitted.chosenAnswerIds.contains(answer.id);

    bool green = selectedByUser != answerIncorrect;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: CheckboxListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(MQTheme.radiusCard),
        ),
        dense: true,
        title: Text(
          answer.text ?? "",
          style: MQTheme.defaultTextStyle,
        ),
        tileColor: green ? Colors.green[300] : Colors.redAccent,
        value: selectedByUser,
        onChanged: null,
      ),
    );
  }

  Widget _singleQuestionResult(BuildContext ctx, QuizQuestion question,
      EvaluatedQuestion result, bool isLast) {
    double maxWidth =
        Provider.of<ScreenSize>(ctx, listen: false).maxWidth * 0.18;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MQTheme.screenPaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((question.imgUrl ?? "").isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.all(MQTheme.radiusCard),
              child: ImageWidget(question.imgUrl!),
            ),
          Padding(
            padding: EdgeInsets.only(
                top: MQTheme.cardPaddingBigV, bottom: MQTheme.cardPaddingBigV),
            child: Text(
              question.text,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          if ((question.description ?? "").isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14, top: 8),
              child: Text(
                question.description!,
                textAlign: TextAlign.center,
              ),
            ),
          ...question.answers.map((a) => _answer(context, a, result)),
          if ((result.answerDetail ?? "").isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Text(
                result.answerDetail ?? "",
                style: MQTheme.defaultTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          if (!isLast)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 14.0, bottom: MQTheme.cardPaddingBigV * 3.14159),
                  child: Container(
                    width: maxWidth,
                    height: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: MQColor.primaryColor),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  Widget _quizResultList(
      BuildContext ctx, QuizSubmissionResponse response) {
    return ListView.builder(
      itemCount: widget.quiz.questions.length,
      itemBuilder: (BuildContext context, int index) {
        return _singleQuestionResult(
            ctx,
            widget.quiz.questions[index],
            response.data!.firstWhere(
              (element) =>
                  element.questionId == widget.quiz.questions[index].id,
            ),
            widget.quiz.questions.length - 1 == index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenTitled(
      titleBar: BasicTitleBar(
        title: (widget.quiz.topic != null) ? widget.quiz.topic!.title : "",
      ),
      child: Container(
        alignment: Alignment.center,
        child: FutureBuilder<QuizSubmissionResponse>(
          future: QuizAPI().evaluateQuizTotal(widget.submission),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error!);
            }
            if (snapshot.hasData) {
              // Get evaluated questions
              List<EvaluatedQuestion> evaluatedQuestions = snapshot.data!.data!;

              // Calculate correct answers and mistakes
              int correctAnswers = _calculateCorrectAnswers(evaluatedQuestions);
              int totalQuestions = widget.quiz.questions.length;
              int mistakes = _calculateMistakes(evaluatedQuestions);

              // Determine result message
              String resultMessage = _getResultMessage(mistakes);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '$correctAnswers / $totalQuestions risposte esatte',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: MQColor.textColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      resultMessage,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: mistakes <= 8
                            ? Colors.green
                            : Colors.redAccent, // Green if passed, red if failed
                      ),
                    ),
                  ),
                  Expanded(
                    child: _quizResultList(context, snapshot.data!),
                  ),
                ],
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
