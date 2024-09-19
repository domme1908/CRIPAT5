import 'dart:convert';
import 'package:flutter/services.dart'; // Required to load local assets
import 'package:munich_data_quiz/api/models.dart';

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
  Future<QuizSubmissionResponse> evaluateQuizTotal(List<QuizSubmission> submissions) async {
    List<EvaluatedQuestion> evaluatedQuestions = [];

    for (var submission in submissions) {
      // Mock evaluation logic: evaluate the submission
      var question = 0;// get the question by its ID from local data
      bool answerCorrect = true; // replace this with actual evaluation logic

      evaluatedQuestions.add(EvaluatedQuestion(
        questionId: submission.questionId,
        answerCorrect: answerCorrect,
        incorrectAnswers: [], // Add incorrect answers based on evaluation
        answerDetail: answerCorrect ? "Correct" : "Incorrect",
      ));
    }

    return QuizSubmissionResponse(
      code: 0,
      title: "Quiz Result",
      message: "Evaluation complete",
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
