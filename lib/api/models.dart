import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cri_pat_5/model/dummy/dummy_assets.dart';

class Topic {
  Topic({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.id,
    required this.questions,
  });

  late final String title;
  late final String? description;
  late final String? imageUrl;
  late final int id;
  late final List<QuizQuestion> questions;

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      title: json["title"],
      description: json["description"],
      imageUrl: json["img_url"],
      id: json["id"],
      questions: List<QuizQuestion>.from(
        json["questions"].map((x) => QuizQuestion.fromJson(x)),
      ),
    );
  }

  // Add this static method to generate a random topic
  static Topic random(BuildContext ctx) {
    return Topic(
      title: AppLocalizations.of(ctx)!.randomTopic,
      description: AppLocalizations.of(ctx)!.randomTopicDescr,
      imageUrl: DummyAssets.randMunichImage, // Replace with your random image
      id: -1, // Use -1 or some identifier to indicate a random topic
      questions: [], // Or provide a few random questions if you like
    );
  }
}

class QuizQuestion {
  QuizQuestion({
    required this.id,
    required this.text,
    this.description,
    this.imgUrl,
    required this.answers,
  });

  final int id;
  final String text;
  final String? description; // Add description
  final String? imgUrl;      // Add imgUrl
  final List<QuizAnswer> answers;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json["id"],
      text: json["text"],
      description: json["description"], // Parse description
      imgUrl: json["img_url"],          // Parse imgUrl
      answers: List<QuizAnswer>.from(
        json["answers"].map((x) => QuizAnswer.fromJson(x)),
      ),
    );
  }
}


class QuizAnswer {
  QuizAnswer({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  final int id;
  final String text;
  final bool isCorrect;

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      id: json["id"],
      text: json["text"],
      isCorrect: json["is_correct"],
    );
  }
}
class GeneratedQuiz {
  GeneratedQuiz({
    required this.topic,
    required this.questions,
  });

  final Topic? topic;
  final List<QuizQuestion> questions;

  factory GeneratedQuiz.fromJson(Map<String, dynamic> json) {
    return GeneratedQuiz(
      topic: json["topic"] == null ? null : Topic.fromJson(json["topic"]),
      questions: json["questions"] == null
          ? []
          : List<QuizQuestion>.from(
              json["questions"].map((x) => QuizQuestion.fromJson(x))),
    );
  }
}
class QuizSubmission {
  QuizSubmission({
    required this.questionId,
    required this.chosenAnswerIds,
  });

  int questionId;
  List<int> chosenAnswerIds;

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "chosen_answer_ids": List<dynamic>.from(chosenAnswerIds.map((x) => x)),
      };
}
class EvaluatedQuestion {
  EvaluatedQuestion({
    required this.questionId,
    required this.answerCorrect,
    required this.incorrectAnswers,
    required this.answerDetail,
  });

  final int questionId;
  final bool? answerCorrect;
  final List<IncorrectAnswer>? incorrectAnswers;
  final String? answerDetail;

  factory EvaluatedQuestion.fromJson(Map<String, dynamic> json) {
    return EvaluatedQuestion(
      questionId: json["question_id"],
      answerCorrect: json["answer_correct"],
      incorrectAnswers: json["incorrect_answers"] == null
          ? null
          : List<IncorrectAnswer>.from(
              json["incorrect_answers"].map((x) => IncorrectAnswer.fromJson(x))),
      answerDetail: json["answer_detail"],
    );
  }
}

class IncorrectAnswer {
  IncorrectAnswer({
    required this.id,
    required this.text,
    required this.correct,
  });

  final int id;
  final String? text;
  final bool? correct;

  factory IncorrectAnswer.fromJson(Map<String, dynamic> json) {
    return IncorrectAnswer(
      id: json["id"],
      text: json["text"],
      correct: json["correct"],
    );
  }
}
class QuizSubmissionResponse {
  QuizSubmissionResponse({
    required this.code,
    required this.title,
    required this.message,
    required this.data,
  });

  final int? code;
  final String? title;
  final String? message;
  final List<EvaluatedQuestion>? data;

  factory QuizSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return QuizSubmissionResponse(
      code: json["code"],
      title: json["title"],
      message: json["message"],
      data: json["data"] == null
          ? null
          : List<EvaluatedQuestion>.from(
              json["data"].map((x) => EvaluatedQuestion.fromJson(x))),
    );
  }
}
