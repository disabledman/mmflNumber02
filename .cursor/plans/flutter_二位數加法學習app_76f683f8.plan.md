---
name: Flutter 二位數加法學習APP
overview: 建立一個 Flutter 應用程式，用於學習二位數加法，包含基礎版（不進位）和進階版（進位），採用分階段答題流程（先答個位數，再答十位數），並包含計分系統和煙火效果。
todos:
  - id: setup
    content: 建立 Flutter 專案結構和基本配置（pubspec.yaml、main.dart）
    status: completed
  - id: home_screen
    content: 實現主畫面，包含基礎版/進階版選擇按鈕和分數顯示
    status: completed
    dependencies:
      - setup
  - id: math_generator
    content: 實現題目生成器，包含基礎版和進階版題目生成邏輯
    status: completed
    dependencies:
      - setup
  - id: game_state
    content: 實現遊戲狀態管理模型，追蹤題目、階段、答案和分數
    status: completed
    dependencies:
      - setup
  - id: addition_display
    content: 實現垂直加法顯示組件，顯示兩個二位數的上下排列
    status: completed
    dependencies:
      - setup
  - id: carrying_hint
    content: 實現進位提示組件，在十位數上方顯示進位數字
    status: completed
    dependencies:
      - addition_display
  - id: answer_options
    content: 實現答案選項組件，根據階段顯示個位數或十位數選項
    status: completed
    dependencies:
      - game_state
  - id: game_screen
    content: 實現遊戲畫面，整合所有組件並實現兩階段答題流程
    status: completed
    dependencies:
      - addition_display
      - carrying_hint
      - answer_options
      - game_state
      - math_generator
  - id: score_system
    content: 實現分數系統，答對加分並在主畫面顯示
    status: completed
    dependencies:
      - game_screen
      - home_screen
  - id: fireworks
    content: 實現煙火效果動畫，答對時顯示
    status: completed
    dependencies:
      - game_screen
  - id: error_handling
    content: 實現錯誤處理，答錯時顯示正確答案
    status: completed
    dependencies:
      - game_screen
  - id: ui_polish
    content: 美化UI，使用色彩豐富的兒童友善設計
    status: completed
    dependencies:
      - home_screen
      - game_screen
---

# Flutter 二位數加法學習APP 開發計畫

## 專案結構

```
lib/
├── main.dart                 # 應用程式入口
├── models/
│   └── game_state.dart      # 遊戲狀態管理
├── screens/
│   ├── home_screen.dart     # 主畫面（選擇基礎版/進階版）
│   └── game_screen.dart     # 遊戲畫面
├── widgets/
│   ├── addition_display.dart    # 垂直加法顯示組件
│   ├── answer_options.dart      # 答案選項組件
│   ├── carrying_hint.dart       # 進位提示組件
│   ├── fireworks_effect.dart    # 煙火效果組件
│   └── score_display.dart       # 分數顯示組件
└── utils/
    └── math_generator.dart      # 題目生成器
```

## 核心功能實現

### 1. 主畫面 (`screens/home_screen.dart`)

- 顯示兩個按鈕：基礎版、進階版
- 顯示當前分數
- 色彩豐富的兒童友善設計

### 2. 遊戲畫面 (`screens/game_screen.dart`)

- 使用 `GameState` 管理遊戲狀態
- 實現兩階段答題流程：
  - 階段1：個位數答題（顯示4個個位數選項）
  - 階段2：十位數答題（顯示4個十位數選項，包含進位）
- 返回主畫面按鈕
- 答對顯示煙火效果
- 答錯顯示正確答案

### 3. 垂直加法顯示 (`widgets/addition_display.dart`)

- 使用 `Column` 和 `Row` 實現垂直加法格式
- 顯示兩個二位數，上下排列
- 十位數上方預留進位提示空間

### 4. 進位提示 (`widgets/carrying_hint.dart`)

- 在十位數上方顯示進位數字（進階版）
- 基礎版不顯示

### 5. 答案選項 (`widgets/answer_options.dart`)

- 顯示4個可能的答案選項
- 根據當前階段（個位數/十位數）顯示對應選項
- 點擊後觸發答案驗證

### 6. 題目生成器 (`utils/math_generator.dart`)

- `generateBasicQuestion()`: 生成不進位題目
- `generateAdvancedQuestion()`: 生成進位題目
- 確保答案選項包含正確答案和3個錯誤選項

### 7. 遊戲狀態管理 (`models/game_state.dart`)

- 當前題目（兩個數字）
- 當前階段（個位數/十位數）
- 已選擇的個位數答案
- 分數
- 遊戲模式（基礎/進階）

### 8. 煙火效果 (`widgets/fireworks_effect.dart`)

- 使用 `AnimationController` 和粒子效果
- 答對時觸發動畫

## 技術要點

- 使用 `StatefulWidget` 管理遊戲狀態
- 使用 `Provider` 或 `setState` 進行狀態管理
- 使用 `Random` 生成題目和錯誤選項
- 使用 `AnimatedContainer` 或自定義動畫實現煙火效果
- 響應式設計，支援不同螢幕尺寸

## 開發順序

1. 建立專案結構和基本導航
2. 實現主畫面
3. 實現題目生成器
4. 實現遊戲狀態管理
5. 實現垂直加法顯示組件
6. 實現答案選項組件
7. 實現兩階段答題流程
8. 實現進位提示
9. 實現分數系統
10. 實現煙火效果
11. 實現錯誤處理和正確答案顯示
12. 美化UI和測試