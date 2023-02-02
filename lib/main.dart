import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'prompt.dart';
import 'control.dart';
import 'score.dart';
import 'game_model.dart';
import 'hit_me_button.dart';
import 'styled_button.dart';

void main() {
  runApp(
    const BullsEyeApp(),
  );
}

class BullsEyeApp extends StatelessWidget {
  const BullsEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    ); // Hiding statusbar or fullscreen
    return const MaterialApp(
      title: 'Bullseye',
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameModel _model;

  @override
  void initState() {
    super.initState();
    _model = GameModel(_randomizeTargetValue());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 48.0,
                  bottom: 32.0,
                ),
                child: Prompt(
                  targetValue: _model.target,
                ),
              ),
              Control(model: _model),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: HitMeButton(
                  text: 'Hit Me!',
                  onPressed: () {
                    _showAlert(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Score(
                  totalScore: _model.totalScore,
                  round: _model.round,
                  onStartOver: () => _startNewGame(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startNewGame() {
    setState(() {
      _model.current = GameModel.sliderStart;
      _model.round = GameModel.roundStart;
      _model.totalScore = GameModel.scoreStart;
      _model.target = _randomizeTargetValue();
    });
  }

  int _pointsForCurrentRound() {
    var maxValue = 100;
    var diff = _differenceAmount();
    return maxValue - diff;
  }

  int _randomizeTargetValue() => Random().nextInt(100) + 1;

  String _alertTitle() {
    var diff = _differenceAmount();
    if (diff == 0) {
      return "Perfect!";
    } else {
      return "Try harder!";
    }
  }

  int _bonusPointReward() {
    var maxValue = 100;
    if (_pointsForCurrentRound() == maxValue) {
      return 100;
    } else if (_pointsForCurrentRound() == (maxValue - 1)) {
      return 50;
    } else {
      return 0;
    }
  }

  int _totalScoreInCurrentRound() =>
      _pointsForCurrentRound() + _bonusPointReward();

  int _differenceAmount() => (_model.target - _model.current).abs();

  void _showAlert(BuildContext context) {
    var okButton = StyledButton(
      icon: Icons.close,
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          _model.totalScore += _totalScoreInCurrentRound();
          _model.target = _randomizeTargetValue();
          _model.round += 1;
        });
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          title: Text(_alertTitle()),
          content: Text('The slider\'s value is ${_model.current}.\n'
              'Your score is ${_totalScoreInCurrentRound()}'),
          actions: [okButton],
          elevation: 15,
        );
      },
    );
  }
}
