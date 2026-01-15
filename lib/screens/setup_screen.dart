import 'package:flutter/material.dart';
import 'player_reveal_screen.dart';
import '../models/game.dart';
import './player_reveal_screen.dart';
class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  double _playersCount = 6.0;
  double _impostersCount = 2.0;

  final List<String> _secretWords = [
    'ELEPHANT', 'PYRAMID', 'SPACESHIP', 'CHOCOLATE', 'VOLCANO',
    'BUTTERFLY', 'MICROSCOPE', 'TELESCOPE', 'HURRICANE', 'JELLYFISH',
    'LIGHTHOUSE', 'KANGAROO', 'WATERFALL', 'SNOWFLAKE', 'FIREWORKS'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back button (top left)
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            
            const Spacer(),
            
       
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.pink,
                  ],
                ).createShader(bounds);
              },
              child: const Text(
                'SETUP GAME',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Players slider
            _buildSlider(
              label: 'PLAYERS',
              value: _playersCount,
              min: 3,
              max: 12,
              onChanged: (value) {
                setState(() {
                  _playersCount = value;
                  if (_impostersCount > _playersCount / 2) {
                    _impostersCount = (_playersCount / 2).floorToDouble();
                  }
                });
              },
              color: Colors.cyan,
            ),
            
            const SizedBox(height: 50),
            
            // Imposters slider
            _buildSlider(
              label: 'IMPOSTERS',
              value: _impostersCount,
              min: 1,
              max: (_playersCount / 2).floorToDouble(),
              onChanged: (value) {
                setState(() {
                  _impostersCount = value;
                });
              },
              color: Colors.pink,
            ),
            
            const SizedBox(height: 60),
            
            // Continue button
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Create the game
                  final game = _createGame();
                  
                 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerRevealScreen(
                        game: game,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Colors.cyan,
                      width: 3,
                    ),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }
  

  Game _createGame() {
    final playerCount = _playersCount.toInt();
    final imposterCount = _impostersCount.toInt();
    
    // Create players list
    final players = List<Player>.generate(playerCount, (index) {
      return Player(
        name: 'Player ${index + 1}',
        isImposter: index < imposterCount,
        hasSeenCard: false,
      );
    });
    
    players.shuffle();
    
    // Get random secret word
    final random = DateTime.now().millisecondsSinceEpoch % _secretWords.length;
    final secretWord = _secretWords[random];
    
    return Game(
      totalPlayers: playerCount,
      impostersCount: imposterCount,
      secretWord: secretWord,
      players: players,
    );
  }
  
  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: color.withOpacity(0.9),
            letterSpacing: 3,
          ),
        ),
        
        const SizedBox(height: 10),
        
        Text(
          value.toInt().toString(),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: color.withOpacity(0.9),
          ),
        ),
        
        const SizedBox(height: 20),
        
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbColor: color,
            activeTrackColor: color,
            inactiveTrackColor: Colors.grey.shade800,
            overlayColor: color.withOpacity(0.3),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}