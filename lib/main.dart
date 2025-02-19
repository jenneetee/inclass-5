import 'dart:async';
import 'package:flutter/material.dart';

//Jennifer Phan & Mariam Omer
void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50;
  Timer? hungerTimer;
  Timer? winTimer;
  int happyStreakSeconds = 0;
  bool _gameEnded = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startWinTimer();
  }

  void _startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_gameEnded) return;
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
        _checkGameOver();
      });
    });
  }

  void _startWinTimer() {
    winTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_gameEnded) return;
      setState(() {
        if (happinessLevel >= 80) {
          happyStreakSeconds++;
        } else {
          happyStreakSeconds = 0;
        }
        if (happyStreakSeconds >= 180) {
          _showWinDialog();
        }
      });
    });
  }

  void _playWithPet() {
    if (_gameEnded) return;
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      energyLevel = (energyLevel - 5).clamp(0, 100);
      _updateHappiness();
      _checkGameOver();
    });
  }

  void _feedPet() {
    if (_gameEnded) return;
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      energyLevel = (energyLevel + 5).clamp(0, 100);
      _updateHappiness();
      _checkGameOver();
    });
  }

  void _updateHappiness() {
    if (hungerLevel > 70) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
    }
  }

  void _checkGameOver() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    if (_gameEnded) return;
    setState(() {
      _gameEnded = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Your pet is too hungry and unhappy!"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                hungerLevel = 50;
                happinessLevel = 50;
                energyLevel = 50;
                happyStreakSeconds = 0;
                _gameEnded = false;
              });
              Navigator.pop(context);
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    if (_gameEnded) return;
    setState(() {
      _gameEnded = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("You Win!"),
        content: Text("Your pet has been very happy for 3 minutes!"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                hungerLevel = 50;
                happinessLevel = 50;
                energyLevel = 50;
                happyStreakSeconds = 0;
                _gameEnded = false;
              });
              Navigator.pop(context);
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  Color _getPetColor() {
    if (happinessLevel > 70) return Colors.greenAccent;
    if (happinessLevel >= 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  String _getPetMood() {
    if (happinessLevel > 70) return "Happy";
    if (happinessLevel >= 30) return "Neutral";
    return "Unhappy";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Digital Pet', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Enter Pet's Name", fillColor: Colors.white),
                  onSubmitted: (value) {
                    setState(() {
                      petName = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16.0),
              CircleAvatar(
                radius: 50,
                backgroundColor: _getPetColor(),
                child: Text(_getPetMood(),
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ),
              SizedBox(height: 8.0),
              Text(
                'Mood: ${_getPetMood()}',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
              Text('Happiness Level: $happinessLevel',
                  style: TextStyle(fontSize: 20.0)),
              Text('Hunger Level: $hungerLevel',
                  style: TextStyle(fontSize: 20.0)),
              Text('Energy Level: $energyLevel',
                  style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              LinearProgressIndicator(value: energyLevel / 100),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _playWithPet,
                child: Text('Play with Your Pet'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _feedPet,
                child: Text('Feed Your Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }
}
