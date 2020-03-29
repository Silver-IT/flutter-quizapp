import 'package:flutter/material.dart';
import '../UI/answer_button.dart';
import '../UI/question_text.dart';
import '../UI/correct_wrong_overlay.dart';
import './score_page.dart';
import '../utils/quiz.dart';
import '../utils/question.dart';

class QuizPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Elon Musk is human", false),
    new Question("Pizza is healthy", false),
    new Question("Flutter is awesome", true),
    new Question("Ecuador is in Africa", false),
    new Question("Dota is world famous game", true),
    new Question("Water flows", true),
    new Question("Neymar is better than Messi", false)
  ]);

  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false))
          ],
        ),
        overlayShouldBeVisible == true ? new CorrectWrongOverlay(isCorrect, () {
          if (quiz.length == questionNumber) {
            Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)),
              (Route route) => route == null);
            return;
          }
          currentQuestion = quiz.nextQuestion;
          this.setState(() {
            overlayShouldBeVisible = false;
            questionText = currentQuestion.question;
            questionNumber = quiz.questionNumber;
          });
        }) : new Container()
      ]
    );
  }
}