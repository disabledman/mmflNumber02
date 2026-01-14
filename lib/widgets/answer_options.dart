import 'package:flutter/material.dart';

class AnswerOptions extends StatelessWidget {
  final List<int> options;
  final Function(int) onAnswerSelected;
  final bool isEnabled;
  final int? selectedAnswer;
  final int? correctAnswer;

  const AnswerOptions({
    super.key,
    required this.options,
    required this.onAnswerSelected,
    this.isEnabled = true,
    this.selectedAnswer,
    this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: options.map((option) {
          bool isSelected = selectedAnswer == option;
          bool isCorrect = correctAnswer != null && option == correctAnswer;
          bool isWrong = isSelected && !isCorrect;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildAnswerButton(
                option,
                isSelected,
                isCorrect,
                isWrong,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnswerButton(
    int option,
    bool isSelected,
    bool isCorrect,
    bool isWrong,
  ) {
    Color backgroundColor;
    Color textColor;

    if (!isEnabled) {
      backgroundColor = Colors.grey.shade300;
      textColor = Colors.grey.shade600;
    } else if (isWrong) {
      backgroundColor = Colors.red.shade300;
      textColor = Colors.red.shade900;
    } else if (isCorrect && selectedAnswer != null) {
      backgroundColor = Colors.green.shade300;
      textColor = Colors.green.shade900;
    } else if (isSelected) {
      backgroundColor = Colors.blue.shade300;
      textColor = Colors.blue.shade900;
    } else {
      backgroundColor = Colors.white;
      textColor = Colors.black87;
    }

    return GestureDetector(
      onTap: isEnabled ? () => onAnswerSelected(option) : null,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? (isWrong ? Colors.red.shade700 : Colors.blue.shade700)
                : Colors.grey.shade400,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            option.toString(),
            style: TextStyle(
              fontSize: option >= 10 ? 28 : 32, // 兩位數使用稍小的字體
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
