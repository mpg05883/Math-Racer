import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MathRacer extends StatefulWidget {
  const MathRacer({super.key});

  @override
  State<MathRacer> createState() => _MathRacerState();
}

class _MathRacerState extends State<MathRacer> {
  bool showStartButton = true;
  final stopwatch = Stopwatch();
  int firstNumber = Random().nextInt(10);
  int secondNumber = Random().nextInt(10);
  int operationNumber = 0;
  String operation = '';
  int correctAnswer = 0;
  String userAnswer = '';
  int userNumber = 0;
  bool isCorrect = false;
  String feedbackMessage = '';
  int questionCount = 0;
  int numQuestions = 10;

  int chooseOperation() {
    return Random().nextInt(3);
  }

  void generateNewQuestion() {
    questionCount++;
    firstNumber = Random().nextInt(10);
    secondNumber = Random().nextInt(10);
    operationNumber = chooseOperation();

    // if operationNumber == 1, it's addition
    if (operationNumber == 1) {
      operation = '+';
      correctAnswer = firstNumber + secondNumber;
    }
    // if operationNumber == 2, it's subtraction
    else if (operationNumber == 2) {
      operation = '-';
      correctAnswer = firstNumber - secondNumber;
    }
    // else - operation is multiplication
    else {
      operation = '*';
      correctAnswer = firstNumber * secondNumber;
    }
    feedbackMessage = '';
    userAnswer = '';

    setState(() {});
  }

  void checkAnswer() {
    setState(() {
      // if user's answer isn't an int:
      if (int.tryParse(userAnswer) == null) {
        feedbackMessage = 'Incorrect. You can only submit whole numbers';
        return;
      }

      // else - init user number
      userNumber = int.parse(userAnswer);

      isCorrect = (userNumber == correctAnswer);
      feedbackMessage = isCorrect
          ? 'Correct! $correctAnswer is the answer!'
          : 'Incorrect. $userNumber is not the answer';

      if (isCorrect) {
        Timer.run(() async {
          await Future.delayed(const Duration(milliseconds: 250));
          generateNewQuestion();
        });
      }
    });
  }

  void startGame() {
    stopwatch.start();
    stopwatch.reset();
    showStartButton = true;
    firstNumber = Random().nextInt(10);
    secondNumber = Random().nextInt(10);
    correctAnswer = 0;
    userAnswer = '';
    userNumber = 0;
    isCorrect = false;
    feedbackMessage = '';
    questionCount = 0;
    showStartButton = true;

    setState(() {
      showStartButton = false; // Hide the start button
      generateNewQuestion(); // Start generating questions
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Math Racer', style: TextStyle(fontSize: 32.0)),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showStartButton)
              ElevatedButton(
                  onPressed: startGame,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Press to start',
                        style: TextStyle(fontSize: 16.0)),
                  )),
            if (!showStartButton)
              Visibility(
                visible: questionCount > numQuestions,
                child: Column(
                  children: [
                    Text(
                      'Congrats!\nYour time is: ${stopwatch.elapsedMilliseconds / 1000} seconds',
                      style: const TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    ElevatedButton(
                      onPressed: startGame,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Play again',
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                  ],
                ),
              ),
            Visibility(
              visible: !showStartButton && questionCount <= numQuestions,
              child: Column(
                children: [
                  Text(
                    'Problem #$questionCount / $numQuestions: What is $firstNumber $operation $secondNumber?',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        userAnswer = value;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  ElevatedButton(
                    onPressed: checkAnswer,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Check answer',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Text(feedbackMessage),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
