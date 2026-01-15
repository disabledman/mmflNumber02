import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_state.dart';
import '../utils/math_generator.dart';
import '../widgets/addition_display.dart';
import '../widgets/answer_options.dart';
import '../widgets/fireworks_effect.dart';
import '../widgets/score_display.dart';
import 'home_screen.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;
  final int initialScore;
  final Function(int) onScoreUpdate;

  const GameScreen({
    super.key,
    required this.mode,
    required this.initialScore,
    required this.onScoreUpdate,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  List<int> _currentOptions = [];
  bool _showFireworks = false;
  bool _isProcessingAnswer = false;

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    setState(() {
      _gameState = widget.mode == GameMode.basic
          ? MathGenerator.generateBasicQuestion()
          : MathGenerator.generateAdvancedQuestion();
      
      _gameState.score = widget.initialScore;
      _gameState.currentStage = AnswerStage.ones;
      _gameState.selectedOnesAnswer = null;
      _gameState.showFireworks = false;
      _gameState.showCorrectAnswer = false;
      _gameState.showFullAnswer = false;
      
      _currentOptions = MathGenerator.generateAnswerOptions(
        _gameState.correctAnswer,
        true, // 個位數階段
      );
      _isProcessingAnswer = false;
    });
  }

  void _handleAnswer(int selectedAnswer) {
    if (_isProcessingAnswer) return;

    setState(() {
      _isProcessingAnswer = true;
    });

    if (_gameState.currentStage == AnswerStage.ones) {
      _handleOnesAnswer(selectedAnswer);
    } else {
      _handleTensAnswer(selectedAnswer);
    }
  }

  void _handleOnesAnswer(int selectedAnswer) {
    bool isCorrect = selectedAnswer == _gameState.onesDigit;

    setState(() {
      _gameState.selectedOnesAnswer = selectedAnswer;
      _gameState.correctOnesAnswer = _gameState.onesDigit;
    });

    if (isCorrect) {
      // 答對個位數，進入十位數階段
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _gameState.currentStage = AnswerStage.tens;
            _currentOptions = MathGenerator.generateAnswerOptions(
              _gameState.correctAnswer,
              false, // 十位數階段
              isAdvanced: _gameState.mode == GameMode.advanced,
            );
            _isProcessingAnswer = false;
          });
        }
      });
    } else {
      // 答錯，顯示正確答案
      setState(() {
        _gameState.showCorrectAnswer = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _generateNewQuestion();
        }
      });
    }
  }

  void _handleTensAnswer(int selectedAnswer) {
    // 進階版比較百位+十位，基礎版比較十位數
    bool isCorrect = _gameState.mode == GameMode.advanced
        ? selectedAnswer == _gameState.tensDigitWithHundreds
        : selectedAnswer == _gameState.tensDigit;

    setState(() {
      // 進階版保存百位+十位，基礎版保存十位數
      _gameState.correctTensAnswer = _gameState.mode == GameMode.advanced
          ? _gameState.tensDigitWithHundreds
          : _gameState.tensDigit;
    });

    if (isCorrect) {
      // 答對，顯示完整答案、煙火效果並加分
      setState(() {
        _gameState.score += 10;
        _gameState.showFullAnswer = true;
        _gameState.showFireworks = true;
        _showFireworks = true;
        widget.onScoreUpdate(_gameState.score);
      });

      // 先顯示煙火效果（1.5秒）
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _showFireworks = false;
            _gameState.showFireworks = false;
          });
        }
      });

      // 不再自動進入下一題，等待用戶點擊"下一題"按鈕
    } else {
      // 答錯，顯示正確答案
      setState(() {
        _gameState.showCorrectAnswer = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _generateNewQuestion();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade200,
                  Colors.purple.shade200,
                  Colors.pink.shade200,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  // 頂部欄：返回按鈕和分數
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, size: 30),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ScoreDisplay(score: _gameState.score),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 階段提示（含進度標示）
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 進度數字標示
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _gameState.currentStage == AnswerStage.ones
                                ? Colors.blue.shade400
                                : Colors.green.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _gameState.currentStage == AnswerStage.ones
                                ? '1/2'
                                : '2/2',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 提示文字
                        Flexible(
                          child: Text(
                            _gameState.currentStage == AnswerStage.ones
                                ? '請先選擇個位數的答案'
                                : (_gameState.mode == GameMode.advanced
                                    ? '請選擇十位數的答案（記得加上進位！）'
                                    : '請選擇十位數的答案'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 加法顯示
                  AdditionDisplay(gameState: _gameState),

                  const SizedBox(height: 40),

                  // 答案選項
                  AnswerOptions(
                    options: _currentOptions,
                    onAnswerSelected: _handleAnswer,
                    isEnabled: !_isProcessingAnswer && !_gameState.showCorrectAnswer,
                    selectedAnswer: _gameState.currentStage == AnswerStage.ones
                        ? _gameState.selectedOnesAnswer
                        : null,
                    correctAnswer: _gameState.currentStage == AnswerStage.ones
                        ? _gameState.correctOnesAnswer
                        : _gameState.correctTensAnswer,
                  ),

                  const SizedBox(height: 30),

                  // 顯示正確答案（答錯時）
                  if (_gameState.showCorrectAnswer)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.red.shade400,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '正確答案是: ${_gameState.correctAnswer}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // 下一題按鈕（答對後顯示）
                  if (_gameState.showFullAnswer && !_showFireworks)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            _generateNewQuestion();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward, size: 24),
                              SizedBox(width: 8),
                              Text(
                                '下一題',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 煙火效果
          if (_showFireworks)
            FireworksEffect(
              onComplete: () {
                // 動畫完成後的處理已在 _handleTensAnswer 中處理
              },
            ),
        ],
      ),
    );
  }
}
