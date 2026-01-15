enum GameMode {
  basic,    // 基礎版（不進位）
  advanced, // 進階版（進位）
}

enum AnswerStage {
  ones,   // 個位數階段
  tens,   // 十位數階段
}

class GameState {
  int num1;
  int num2;
  GameMode mode;
  AnswerStage currentStage;
  int? selectedOnesAnswer;
  int score;
  bool showFireworks;
  bool showCorrectAnswer;
  bool showFullAnswer; // 顯示完整答案（答對後）
  bool showOnesAnswer; // 顯示個位數答案（個位數答對後）
  int? correctOnesAnswer;
  int? correctTensAnswer;

  GameState({
    required this.num1,
    required this.num2,
    required this.mode,
    this.currentStage = AnswerStage.ones,
    this.selectedOnesAnswer,
    this.score = 0,
    this.showFireworks = false,
    this.showCorrectAnswer = false,
    this.showFullAnswer = false,
    this.showOnesAnswer = false,
    this.correctOnesAnswer,
    this.correctTensAnswer,
  });

  int get correctAnswer => num1 + num2;
  
  int get onesDigit => correctAnswer % 10;
  
  int get tensDigit => (correctAnswer ~/ 10) % 10;
  
  // 進階版十位數答案：百位+十位（例如：148 -> 14）
  int get tensDigitWithHundreds => correctAnswer ~/ 10;
  
  int get carryOver => (num1 % 10 + num2 % 10) ~/ 10;

  GameState copyWith({
    int? num1,
    int? num2,
    GameMode? mode,
    AnswerStage? currentStage,
    int? selectedOnesAnswer,
    int? score,
    bool? showFireworks,
    bool? showCorrectAnswer,
    bool? showFullAnswer,
    bool? showOnesAnswer,
    int? correctOnesAnswer,
    int? correctTensAnswer,
  }) {
    return GameState(
      num1: num1 ?? this.num1,
      num2: num2 ?? this.num2,
      mode: mode ?? this.mode,
      currentStage: currentStage ?? this.currentStage,
      selectedOnesAnswer: selectedOnesAnswer ?? this.selectedOnesAnswer,
      score: score ?? this.score,
      showFireworks: showFireworks ?? this.showFireworks,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
      showFullAnswer: showFullAnswer ?? this.showFullAnswer,
      showOnesAnswer: showOnesAnswer ?? this.showOnesAnswer,
      correctOnesAnswer: correctOnesAnswer ?? this.correctOnesAnswer,
      correctTensAnswer: correctTensAnswer ?? this.correctTensAnswer,
    );
  }
}
