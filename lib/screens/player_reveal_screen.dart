import 'package:flutter/material.dart';
import '../models/game.dart';  // Import Game model

class PlayerRevealScreen extends StatefulWidget {
  final Game game;
  
  const PlayerRevealScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<PlayerRevealScreen> createState() => _PlayerRevealScreenState();
}

class _PlayerRevealScreenState extends State<PlayerRevealScreen> {
  bool _cardFlipped = false;
  late Player _currentPlayer;

  @override
  void initState() {
    super.initState();
    // Get current player based on index
    _currentPlayer = widget.game.players[widget.game.currentPlayerIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Player indicator
            Text(
              _currentPlayer.name.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 3,
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'TAP CARD TO REVEAL',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 2,
              ),
            ),
            
            // Progress indicator
            Text(
              '${widget.game.currentPlayerIndex + 1}/${widget.game.totalPlayers}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Flip card
            GestureDetector(
              onTap: () {
                setState(() {
                  _cardFlipped = true;
                  _currentPlayer.hasSeenCard = true;
                });
              },
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _cardFlipped ? Colors.pink : Colors.cyan,
                    width: 4,
                  ),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: _cardFlipped 
                          ? Colors.pink.withOpacity(0.5)
                          : Colors.cyan.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: _cardFlipped 
                    ? _buildCardFront()
                    : _buildCardBack(),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Next button (only shows after flip)
            if (_cardFlipped)
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
                  onPressed: _goToNextPlayer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                        color: Colors.cyan,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.game.currentPlayerIndex < widget.game.totalPlayers - 1
                        ? 'PASS TO NEXT PLAYER'
                        : 'START DISCUSSION',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  void _goToNextPlayer() {
    if (widget.game.currentPlayerIndex < widget.game.totalPlayers - 1) {
      // Move to next player
      widget.game.currentPlayerIndex++;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerRevealScreen(
            game: widget.game,
          ),
        ),
      );
    } else {
      // All players have seen their cards - go to game start
      _startGameDiscussion();
    }
  }
  
  void _startGameDiscussion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [Colors.cyan, Colors.pink],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'GAME READY!',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                Text(
                  'Word: ${widget.game.secretWord}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  '${widget.game.impostersCount} Imposter${widget.game.impostersCount > 1 ? 's' : ''} among ${widget.game.totalPlayers} players',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
                
                const SizedBox(height: 50),
                
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Start discussion/timer screen (you'll create this next)
                      print('Starting discussion round');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Colors.pink,
                          width: 3,
                        ),
                      ),
                    ),
                    child: const Text(
                      'START DISCUSSION',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCardBack() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_mark_rounded,
            color: Colors.cyan.withOpacity(0.9),
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            'TAP TO REVEAL\nYOUR ROLE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.cyan.withOpacity(0.9),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCardFront() {
    // Get list of other imposters (for imposter players)
    List<String> otherImposters = [];
    if (_currentPlayer.isImposter) {
      otherImposters = widget.game.players
          .where((p) => p.isImposter && p.name != _currentPlayer.name)
          .map((p) => p.name)
          .toList();
    }
    
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Role
          Text(
            _currentPlayer.isImposter ? 'IMPOSTER' : 'CIVILIAN',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: _currentPlayer.isImposter ? Colors.pink : Colors.cyan,
              letterSpacing: 2,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Content
          if (_currentPlayer.isImposter) ...[
            const Text(
              'YOU DO NOT KNOW\nTHE SECRET WORD',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (otherImposters.isNotEmpty)
              Column(
                children: [
                  Text(
                    'OTHER IMPOSTERS:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    otherImposters.join('\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ] else ...[
            Text(
              'SECRET WORD:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.cyan.withOpacity(0.8),
              ),
            ),
            
            const SizedBox(height: 15),
            
            Text(
              widget.game.secretWord,
              style: const TextStyle(
                fontSize: 42,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}