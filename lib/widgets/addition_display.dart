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
    int answer = gameState.correctAnswer;
    
    // 計算最大位數（用於確定網格列數）
    int maxDigits = _getMaxDigits(num1, num2, answer);
    
    // 獲取各位數
    List<int?> num1Digits = _getDigits(num1, maxDigits);
    List<int?> num2Digits = _getDigits(num2, maxDigits);
    List<int?> answerDigits = _getDigits(answer, maxDigits);

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
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildCarryRow(gameState.carryOver, maxDigits),
            ),
          
          // 網格表格
          _buildGridTable(
            num1Digits,
            num2Digits,
            answerDigits,
            maxDigits,
          ),
        ],
      ),
    );
  }

  int _getMaxDigits(int num1, int num2, int answer) {
    int max = num1;
    if (num2 > max) max = num2;
    if (answer > max) max = answer;
    return max.toString().length;
  }

  List<int?> _getDigits(int number, int maxDigits) {
    List<int?> digits = [];
    String numStr = number.toString();
    int numLength = numStr.length;
    
    // 左側補空（null）以對齊位數，不顯示前導零
    for (int i = 0; i < maxDigits; i++) {
      if (i < maxDigits - numLength) {
        digits.add(null); // 左側留空
      } else {
        digits.add(int.parse(numStr[i - (maxDigits - numLength)]));
      }
    }
    return digits;
  }

  Widget _buildCarryRow(int carryOver, int maxDigits) {
    if (carryOver == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 加號列（與表格對齊）
        SizedBox(width: 60, height: 40),
        // 數字列（進位顯示在十位數上方）
        ...List.generate(maxDigits, (index) {
          if (index == maxDigits - 2) {
            // 十位數位置顯示進位
            return Container(
              width: 60,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade600,
                  width: 2,
                ),
              ),
              child: Text(
                carryOver.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return SizedBox(width: 60, height: 40);
          }
        }),
      ],
    );
  }

  Widget _buildGridTable(
    List<int?> num1Digits,
    List<int?> num2Digits,
    List<int?> answerDigits,
    int maxDigits,
  ) {
    bool isOnesStage = gameState.currentStage == AnswerStage.ones;
    bool isTensStage = gameState.currentStage == AnswerStage.tens;
    bool showAnswer = gameState.showFullAnswer;
    bool showOnesAnswer = gameState.showOnesAnswer;

    return Table(
      border: TableBorder(), // 無邊框，網格線不可見
      defaultColumnWidth: const FixedColumnWidth(60),
      children: [
        // 第一行：第一個數字
        TableRow(
          children: [
            _buildTableCell('', 60, null, false),
            ...num1Digits.asMap().entries.map((entry) {
              int index = entry.key;
              int? digit = entry.value;
              bool isHighlighted = false;
              Color? textColor = Colors.black87;
              
              // 判斷是否高亮（個位數或十位數階段）
              if (index == maxDigits - 1 && isOnesStage && digit != null) {
                isHighlighted = true;
                textColor = Colors.blue.shade900;
              } else if (index == maxDigits - 2 && isTensStage && digit != null) {
                isHighlighted = true;
                textColor = Colors.orange.shade900;
              }
              
              return _buildTableCell(
                digit?.toString() ?? '',
                60,
                isHighlighted
                    ? BoxDecoration(
                        color: index == maxDigits - 1
                            ? Colors.blue.shade200
                            : Colors.yellow.shade200,
                        border: Border.all(
                          color: index == maxDigits - 1
                              ? Colors.blue.shade400
                              : Colors.orange.shade400,
                          width: 2,
                        ),
                      )
                    : null,
                false,
                textColor: textColor,
                fontSize: 36,
              );
            }).toList(),
          ],
        ),
        // 第二行：第二個數字（加號在左邊）
        TableRow(
          children: [
            _buildTableCell('+', 60, null, false, fontSize: 32),
            ...num2Digits.asMap().entries.map((entry) {
              int index = entry.key;
              int? digit = entry.value;
              bool isHighlighted = false;
              Color? textColor = Colors.black87;
              
              // 判斷是否高亮
              if (index == maxDigits - 1 && isOnesStage && digit != null) {
                isHighlighted = true;
                textColor = Colors.blue.shade900;
              } else if (index == maxDigits - 2 && isTensStage && digit != null) {
                isHighlighted = true;
                textColor = Colors.orange.shade900;
              }
              
              return _buildTableCell(
                digit?.toString() ?? '',
                60,
                isHighlighted
                    ? BoxDecoration(
                        color: index == maxDigits - 1
                            ? Colors.blue.shade200
                            : Colors.yellow.shade200,
                        border: Border.all(
                          color: index == maxDigits - 1
                              ? Colors.blue.shade400
                              : Colors.orange.shade400,
                          width: 2,
                        ),
                      )
                    : null,
                false,
                textColor: textColor,
                fontSize: 36,
              );
            }).toList(),
          ],
        ),
        // 第四行：答案（如果顯示）
        if (showAnswer || showOnesAnswer)
          TableRow(
            children: [
              _buildTableCell('', 60, null, false, fontSize: 72), // 確保高度一致
              ...answerDigits.asMap().entries.map((entry) {
                int index = entry.key;
                int? digit = entry.value;
                
                // 如果只顯示個位數答案，其他位數留空
                if (showOnesAnswer && !showAnswer) {
                  // 只顯示個位數（最後一列）
                  if (index == maxDigits - 1) {
                    return _buildTableCell(
                      digit?.toString() ?? '',
                      60,
                      null,
                      false,
                      textColor: Colors.green,
                      fontSize: 72,
                    );
                  } else {
                    return _buildTableCell('', 60, null, false, fontSize: 72);
                  }
                } else {
                  // 顯示完整答案
                  return _buildTableCell(
                    digit?.toString() ?? '',
                    60,
                    null,
                    false,
                    textColor: Colors.green,
                    fontSize: 72, // 放大2倍：從36改為72
                  );
                }
              }).toList(),
            ],
          ),
      ],
    );
  }

  Widget _buildTableCell(
    String content,
    double size,
    BoxDecoration? decoration,
    bool isEmpty, {
    Color? textColor,
    double? fontSize,
  }) {
    // 答案行需要更大的高度以容納大字體
    double cellHeight = (fontSize != null && fontSize > 50) ? size * 1.8 : size;
    
    return Container(
      width: size,
      height: cellHeight,
      decoration: decoration,
      alignment: Alignment.center,
      child: Text(
        content,
        style: TextStyle(
          fontSize: fontSize ?? 24,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGridCell(
    String content,
    double size,
    BoxDecoration? decoration,
    bool isEmpty,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: decoration,
      alignment: Alignment.center,
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
