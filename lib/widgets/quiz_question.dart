import 'package:flutter/material.dart';
import 'package:cri_pat_5/api/models.dart';
import 'package:cri_pat_5/constants/theme.dart';
import 'package:cri_pat_5/widgets/image_widget.dart';

class QuizQuestionWidget extends StatefulWidget {
  const QuizQuestionWidget(this.question, this.selectedAnswers, {Key? key})
      : super(key: key);

  final QuizQuestion question;

  // This map<int, bool> maps the answer id to a boolean indicating a selection
  final Map<int, bool> selectedAnswers;

  @override
  _QuizQuestionWidgetState createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  static const titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // To track the selected answer's ID for this particular question
  int? selectedAnswerId;

  @override
  void initState() {
    super.initState();
    // Initialize selectedAnswerId based on any pre-existing selection in selectedAnswers map
    selectedAnswerId = widget.selectedAnswers.entries
        .firstWhere((entry) => entry.value, orElse: () => MapEntry(-1, false))
        .key;
    if (selectedAnswerId == -1) {
      selectedAnswerId = null;
    }
  }

  void _handleAnswerSelection(int answerId) {
    setState(() {
      // Update the selected answer ID
      selectedAnswerId = answerId;

      // Clear the selectedAnswers map and set the new selected answer to true
      widget.selectedAnswers.clear();
      widget.selectedAnswers[answerId] = true;
    });
  }

  Widget _answer(BuildContext context, QuizAnswer answer) {
    return AnswerRadioButton(
      answer: answer,
      isSelected: selectedAnswerId == answer.id,
      onSelected: () => _handleAnswerSelection(answer.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: MQTheme.screenPaddingH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if ((widget.question.imgUrl ?? "").isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.all(MQTheme.radiusCard),
                child: ImageWidget(widget.question.imgUrl!),
              ),
            Padding(
              padding: EdgeInsets.only(
                top: MQTheme.cardPaddingBigV,
                bottom: MQTheme.cardPaddingV,
              ),
              child: Text(
                widget.question.text,
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            if ((widget.question.description ?? "").isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  widget.question.description!,
                  textAlign: TextAlign.center,
                ),
              ),
            // Build the list of answers
            ...widget.question.answers.map((a) => _answer(context, a)),
          ],
        ),
      ),
    );
  }
}

class AnswerRadioButton extends StatelessWidget {
  const AnswerRadioButton({
    Key? key,
    required this.answer,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  final QuizAnswer answer;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<int>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(MQTheme.radiusCard),
      ),
      dense: true,
      title: Text(
        answer.text ?? "",
        style: MQTheme.defaultTextStyle,
      ),
      groupValue: isSelected ? answer.id : null,
      value: answer.id,
      onChanged: (int? newValue) {
        // Call the provided callback to handle selection
        onSelected();
      },
    );
  }
}
