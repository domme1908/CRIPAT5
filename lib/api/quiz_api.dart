import 'dart:convert';
import 'package:flutter/services.dart'; // Required to load local assets
import 'package:cri_pat_5/api/models.dart';

class QuizAPI {
  // Singleton: the QuizAPI "constructor" always returns the same object
  static final instance = QuizAPI._internal();
  factory QuizAPI() {
    return instance;
  }

  // Actual, private constructor
  QuizAPI._internal();
  
  Future<List<Topic>> topics() async {
    // Load the JSON file from assets
    final String jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    // Convert the JSON data into a list of Topic objects
    return jsonData.map((topicData) => Topic.fromJson(topicData)).toList();
  }

  // Load JSON from assets and parse it into a list of topics
  Future<List<Topic>> loadTopicsFromAssets() async {
    // Replace with the actual path to your local questions JSON
    final String jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData.map((topicData) => Topic.fromJson(topicData)).toList();
  }
Future<QuizSubmissionResponse> evaluateQuizTotal(
    List<QuizSubmission> submissions) async {
  // Load the questions from the JSON file
  final String jsonString = await rootBundle.loadString('assets/questions.json');
  final List<dynamic> jsonData = jsonDecode(jsonString);
  final List<Topic> topics = jsonData.map((topicData) => Topic.fromJson(topicData)).toList();

  List<EvaluatedQuestion> evaluatedQuestions = [];

  // Loop through each submission to evaluate the answer
  for (var submission in submissions) {
    // Find the question by its ID
    QuizQuestion? question;
    for (var topic in topics) {
      for (var q in topic.questions) {
        if (q.id == submission.questionId) {
          question = q;
          break;
        }
      }
      if (question != null) break;
    }

    // If question is found, evaluate it
    if (question != null) {
      // Get the user's chosen answer IDs
      List<int> chosenAnswers = submission.chosenAnswerIds;

      // Determine if the answer is correct
      bool answerCorrect = false;
      List<IncorrectAnswer> incorrectAnswers = [];

      for (var answer in question.answers) {
        if (chosenAnswers.contains(answer.id)) {
          if (answer.isCorrect) {
            answerCorrect = true; // Correct answer selected
          } else {
            incorrectAnswers.add(IncorrectAnswer(
              id: answer.id,
              text: answer.text,
              correct: answer.isCorrect,
            ));
          }
        }
      }

      // Add the evaluated question to the results
      evaluatedQuestions.add(EvaluatedQuestion(
        questionId: question.id,
        answerCorrect: answerCorrect,
        incorrectAnswers: incorrectAnswers,
        answerDetail: answerCorrect ? "Corretto" : "Sbagliato",
      ));
    }
  }

  // Return the evaluation results
  return QuizSubmissionResponse(
    code: 0,
    title: "Risultato",
    message: "Quiz valutato",
    data: evaluatedQuestions,
  );
}

  // Method to generate a quiz for a specific topic
  Future<GeneratedQuiz> generateQuiz(int topicId, [int size = 10]) async {
    // Load topics and find the one matching the given topicId
    List<Topic> topics = await loadTopicsFromAssets();
    Topic topic = topics.firstWhere((t) => t.id == topicId);

    // Limit the number of questions to the 'size' parameter
    List<QuizQuestion> selectedQuestions = topic.questions.take(size).toList();

    // Return the GeneratedQuiz with the topic and the selected questions
    return GeneratedQuiz(
      topic: topic,
      questions: selectedQuestions,
    );
  }
}
