# 二位數加法學習APP

一個使用 Flutter 開發的數學學習應用程式，幫助學習二位數加法和進位概念。

## 功能特色

- **基礎版**：不需要進位的二位數加法練習
- **進階版**：需要進位的二位數加法練習
- **兩階段答題**：先答個位數，再答十位數
- **進位提示**：在進階版中顯示進位數字
- **計分系統**：答對題目可獲得積分
- **煙火效果**：答對時顯示慶祝動畫
- **色彩豐富的UI**：適合兒童使用的友善介面

## 系統需求

- Flutter SDK 3.0.0 或更高版本
- Dart SDK 3.0.0 或更高版本

## 安裝與執行

1. 確保已安裝 Flutter SDK
2. 在專案目錄中執行：
   ```bash
   flutter pub get
   ```
3. 執行應用程式：
   ```bash
   flutter run
   ```

### 網頁版本

此應用程式支援在網頁瀏覽器中執行：

**開發模式（熱重載）：**
```bash
flutter run -d chrome
```

**建置網頁版本：**
```bash
flutter build web
```

建置完成後，檔案會產生在 `build/web` 目錄中，可以使用任何網頁伺服器來部署。

**本地測試建置版本：**
```bash
# 使用 Python 簡單伺服器
cd build/web
python -m http.server 8000
# 或使用 Node.js http-server
npx http-server -p 8000
```

然後在瀏覽器中開啟 `http://localhost:8000`

## 專案結構

```
lib/
├── main.dart                 # 應用程式入口
├── models/
│   └── game_state.dart      # 遊戲狀態管理
├── screens/
│   ├── home_screen.dart     # 主畫面
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

## 遊戲流程

1. 在主畫面選擇「基礎版」或「進階版」
2. 題目出現後，先選擇個位數的答案
3. 答對個位數後，會顯示進位提示（進階版）
4. 再選擇十位數的答案（記得加上進位）
5. 答對全部答案後會顯示煙火效果並加分
6. 答錯會顯示正確答案，2秒後自動進入下一題

## 技術說明

- 使用 `StatefulWidget` 管理遊戲狀態
- 使用 `AnimationController` 實現煙火動畫效果
- 響應式設計，支援不同螢幕尺寸
- 使用 Material Design 3 設計系統
