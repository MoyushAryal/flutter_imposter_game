class Game {
  final int totalPlayers;
  final int impostersCount;
  final String secretWord;
  final List<Player> players;
  int currentPlayerIndex = 0;

  Game({
    required this.totalPlayers,
    required this.impostersCount,
    required this.secretWord,
    required this.players,
  });
}

class Player {
  final String name;
  final bool isImposter;
  bool hasSeenCard;

  Player({
    required this.name,
    required this.isImposter,
    this.hasSeenCard = false,
  });
}