import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'carrying_hint.dart';

class AdditionDisplay extends StatelessWidget {
  final GameState gameState;

  const AdditionDisplay({
    super.key,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    int num1 = gameState.num1;
    int num2 = gameState.num2;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 進位提示（僅在進階版且十位數階段顯示）
          if (gameState.mode == GameMode.advanced &&
              gameState.currentStage == AnswerStage.tens)
            CarryingHint(carryOver: gameState.carryOver),
          
          // 第一個數字
          _buildNumberRow(num1, true),
          
          // 加號
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 10),
                // 十位數位置
                const SizedBox(width: 50),
                const SizedBox(width: 10),
                // 個位數位置
                const SizedBox(width: 50),
              ],
            ),
          ),
          
          // 第二個數字
          _buildNumberRow(num2, false),
          
          // 分隔線
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 40), // + 號寬度
                const SizedBox(width: 10),
                SizedBox(
                  width: 120, // 兩個數字位數的總寬度
                  child: Divider(
                    thickness: 2,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // 顯示完整答案（答對後）
          if (gameState.showFullAnswer)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _buildAnswerRow(gameState.correctAnswer),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(int answer) {
    int hundreds = answer ~/ 100;
    int tens = (answer ~/ 10) % 10;
    int ones = answer % 10;
    bool hasHundreds = hundreds > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 40), // + 號位置
        const SizedBox(width: 10),
        // 百位數（如果有，顯示在十位數左邊）
        if (hasHundreds)
          Container(
            width: 50,
            height: 120,
            alignment: Alignment.center,
            child: Text(
              hundreds.toString(),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        if (hasHundreds) const SizedBox(width: 10),
        // 十位數（對齊到上面數字的十位數位置）
        Container(
          width: 50,
          height: 120,
          alignment: Alignment.center,
          child: Text(
            tens.toString(),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // 個位數（對齊到上面數字的個位數位置）
        Container(
          width: 50,
          height: 120,
          alignment: Alignment.center,
          child: Text(
            ones.toString(),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberRow(int number, bool isFirstNumber) {
    int tens = number ~/ 10;
    int ones = number % 10;
    bool isOnesStage = gameState.currentStage == AnswerStage.ones;
    bool isTensStage = gameState.currentStage == AnswerStage.tens;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 40), // + 號位置
        const SizedBox(width: 10),
        // 十位數（上方預留進位空間）
        Container(
          width: 50,
          height: 60,
          alignment: Alignment.center,
          decoration: isTensStage
              ? BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.shade400,
                    width: 2,
                  ),
                )
              : null,
          child: Text(
            tens.toString(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isTensStage
                  ? Colors.orange.shade900
                  : Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // 個位數
        Container(
          width: 50,
          height: 60,
          alignment: Alignment.center,
          decoration: isOnesStage
              ? BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.shade400,
                    width: 2,
                  ),
                )
              : null,
          child: Text(
            ones.toString(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isOnesStage
                  ? Colors.blue.shade900
                  : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
