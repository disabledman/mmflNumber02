import 'dart:math';
import '../models/game_state.dart';

class MathGenerator {
  static final Random _random = Random();

  static GameState generateBasicQuestion() {
    // 基礎版：確保個位數相加不超過9（不進位）且總和不超過100
    int num1 = 10;
    int num2 = 10;
    int attempts = 0;
    
    do {
      // 生成第一個數字（10-90，確保至少留10給num2）
      num1 = _random.nextInt(81) + 10; // 10-90
      int ones1 = num1 % 10;
      
      // 計算 num2 的最大值（確保總和不超過100）
      int maxNum2 = 100 - num1;
      if (maxNum2 < 10) {
        continue; // 重新生成
      }
      
      // 生成 num2 的十位數（1-9，但不能超過maxNum2的十位數）
      // 同時確保十位數相加不等於10
      int maxTens2 = (maxNum2 ~/ 10).clamp(1, 9);
      int tens1 = num1 ~/ 10;
      int tens2;
      
      // 如果 tens1 + maxTens2 可能等於10，需要限制範圍
      if (tens1 + maxTens2 >= 10) {
        // 確保 tens1 + tens2 < 10
        int maxAllowedTens2 = 9 - tens1;
        if (maxAllowedTens2 < 1) {
          continue; // 無法生成，重新開始
        }
        tens2 = _random.nextInt(maxAllowedTens2.clamp(1, maxTens2)) + 1;
      } else {
        tens2 = _random.nextInt(maxTens2) + 1; // 至少是1，確保num2是兩位數
      }
      
      // 生成 num2 的個位數，確保：
      // 1. 個位數相加不超過9（不進位）
      // 2. 不超過 maxNum2 的個位數限制
      int maxOnes2ForNoCarry = 9 - ones1; // 不進位的最大個位數
      int maxOnes2ForSum = maxNum2 % 10; // 總和限制的最大個位數
      int maxOnes2 = maxOnes2ForNoCarry < maxOnes2ForSum 
          ? maxOnes2ForNoCarry 
          : maxOnes2ForSum;
      maxOnes2 = maxOnes2.clamp(0, 9);
      
      int ones2 = _random.nextInt(maxOnes2 + 1);
      num2 = tens2 * 10 + ones2;
      
      // 確保 num2 是兩位數且總和不超過100
      if (num2 < 10) {
        num2 = 10;
      }
      
      attempts++;
      if (attempts > 100) {
        // 防止無限循環，使用簡單的默認值
        num1 = 50;
        num2 = 50;
        break;
      }
    } while (num1 + num2 > 100 || 
             (num1 % 10) + (num2 % 10) > 9 || 
             num2 < 10 ||
             (num1 ~/ 10) + (num2 ~/ 10) == 10); // 確保十位數相加不等於10

    return GameState(
      num1: num1,
      num2: num2,
      mode: GameMode.basic,
    );
  }

  static GameState generateAdvancedQuestion() {
    // 進階版：確保個位數相加會進位（>=10），且可以超過100
    int num1, num2;
    int attempts = 0;
    
    do {
      num1 = _random.nextInt(90) + 10; // 10-99
      num2 = _random.nextInt(90) + 10; // 10-99
      
      // 確保個位數相加會進位
      int ones1 = num1 % 10;
      int ones2 = num2 % 10;
      
      if (ones1 + ones2 < 10) {
        // 調整個位數使其進位
        int minOnes2 = 10 - ones1;
        
        // 如果 minOnes2 > 9，說明 ones1 = 0，無法通過調整 ones2 來進位
        // 需要重新生成 num1（個位數不能為0）
        if (minOnes2 > 9) {
          continue; // 重新生成
        }
        
        // 計算可用的個位數範圍：從 minOnes2 到 9
        int range = 10 - minOnes2; // 9 - minOnes2 + 1 = 10 - minOnes2
        if (range > 0) {
          int newOnes2 = minOnes2 + _random.nextInt(range);
          num2 = (num2 ~/ 10) * 10 + newOnes2;
        } else {
          // 如果 range <= 0（理論上不應該發生），設置為最小值
          num2 = (num2 ~/ 10) * 10 + minOnes2;
        }
      }
      
      // 驗證個位數相加會進位
      int ones1Final = num1 % 10;
      int ones2Final = num2 % 10;
      
      attempts++;
      if (attempts > 100) {
        // 防止無限循環，使用默認值（強制進位）
        num1 = 11;
        num2 = 19; // 1 + 9 = 10，會進位
        break;
      }
    } while ((num1 % 10) + (num2 % 10) < 10);
    
    // 進階版允許答案超過100，所以不需要限制總和

    return GameState(
      num1: num1,
      num2: num2,
      mode: GameMode.advanced,
    );
  }

  static List<int> generateAnswerOptions(int correctAnswer, bool isOnesStage, {bool isAdvanced = false}) {
    Set<int> options = {};
    
    if (isOnesStage) {
      // 個位數選項：正確答案的個位數 + 3個錯誤選項
      int correctOnes = correctAnswer % 10;
      options.add(correctOnes);
      
      while (options.length < 4) {
        int wrongOnes = _random.nextInt(10);
        if (wrongOnes != correctOnes) {
          options.add(wrongOnes);
        }
      }
    } else {
      // 十位數選項
      if (isAdvanced) {
        // 進階版：百位+十位（例如：148 -> 14）
        int correctTensWithHundreds = correctAnswer ~/ 10;
        options.add(correctTensWithHundreds);
        
        // 生成3個不同的錯誤選項（百位+十位的組合）
        // 可能的範圍：10-99（兩位數）
        List<int> wrongOptions = [];
        for (int i = 10; i < 100; i++) {
          if (i != correctTensWithHundreds) {
            wrongOptions.add(i);
          }
        }
        wrongOptions.shuffle(_random);
        
        // 添加3個錯誤選項
        for (int i = 0; i < 3 && i < wrongOptions.length; i++) {
          options.add(wrongOptions[i]);
        }
        
        // 如果還是沒有4個選項，強制添加其他數字
        if (options.length < 4) {
          for (int i = 10; i < 100 && options.length < 4; i++) {
            if (i != correctTensWithHundreds && !options.contains(i)) {
              options.add(i);
            }
          }
        }
      } else {
        // 基礎版：僅十位數（0-9）
        int correctTens = (correctAnswer ~/ 10) % 10;
        options.add(correctTens);
        
        // 生成3個不同的錯誤選項
        List<int> wrongOptions = [];
        for (int i = 0; i < 10; i++) {
          if (i != correctTens) {
            wrongOptions.add(i);
          }
        }
        wrongOptions.shuffle(_random);
        
        // 添加3個錯誤選項
        for (int i = 0; i < 3 && i < wrongOptions.length; i++) {
          options.add(wrongOptions[i]);
        }
        
        // 如果還是沒有4個選項（理論上不應該發生），強制添加其他數字
        if (options.length < 4) {
          for (int i = 0; i < 10 && options.length < 4; i++) {
            if (i != correctTens && !options.contains(i)) {
              options.add(i);
            }
          }
        }
      }
    }
    
    List<int> optionsList = options.toList();
    
    // 驗證正確答案在選項中（在打亂前）
    if (isOnesStage) {
      int correctOnes = correctAnswer % 10;
      if (!optionsList.contains(correctOnes)) {
        // 如果不在選項中，強制添加
        optionsList.removeAt(0);
        optionsList.add(correctOnes);
      }
    } else {
      if (isAdvanced) {
        int correctTensWithHundreds = correctAnswer ~/ 10;
        if (!optionsList.contains(correctTensWithHundreds)) {
          // 如果不在選項中，強制添加
          optionsList.removeAt(0);
          optionsList.add(correctTensWithHundreds);
        }
      } else {
        int correctTens = (correctAnswer ~/ 10) % 10;
        if (!optionsList.contains(correctTens)) {
          // 如果不在選項中，強制添加
          optionsList.removeAt(0);
          optionsList.add(correctTens);
        }
      }
    }
    
    // 打亂選項順序
    optionsList.shuffle(_random);
    
    // 最終驗證
    if (isOnesStage) {
      int correctOnes = correctAnswer % 10;
      assert(optionsList.contains(correctOnes), 
        '個位數正確答案 $correctOnes 不在選項中，選項=$optionsList');
    } else {
      if (isAdvanced) {
        int correctTensWithHundreds = correctAnswer ~/ 10;
        assert(optionsList.contains(correctTensWithHundreds), 
          '十位數（百位+十位）正確答案 $correctTensWithHundreds 不在選項中，正確答案=$correctAnswer，選項=$optionsList');
      } else {
        int correctTens = (correctAnswer ~/ 10) % 10;
        assert(optionsList.contains(correctTens), 
          '十位數正確答案 $correctTens 不在選項中，正確答案=$correctAnswer，選項=$optionsList');
      }
    }
    
    return optionsList;
  }
}
