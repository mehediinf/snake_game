# 🐍 সাপের খেলা — Snake Game (Flutter)

ছোট বাচ্চাদের জন্য সম্পূর্ণ Offline Flutter Snake Game।

---

## 🌟 ফিচার

- ✅ **সম্পূর্ণ Offline** — ইন্টারনেট ছাড়াই চলে
- ✅ **৩টি গতি** — ধীর 🐢 / মধ্যম 🐇 / দ্রুত ⚡
- ✅ **D-Pad + Swipe** — দুইভাবে নিয়ন্ত্রণ
- ✅ **চোখসহ সাপের মাথা** — সুন্দর গ্রাফিক্স
- ✅ **৫ ধরনের খাবার** 🍎🍊🍇🍓🌟 — আলাদা পয়েন্ট
- ✅ **লেভেল সিস্টেম** — ৫টি খাবার খেলে লেভেল বাড়ে
- ✅ **High Score সেভ** — SharedPreferences দিয়ে
- ✅ **Pause/Resume** — মাঝে বিরতি নেওয়া যাবে
- ✅ **নতুন রেকর্ড** সনাক্ত করে

---

## 🚀 চালানোর নিয়ম

```bash
cd snake_game
flutter pub get
flutter run

# APK বানাতে:
flutter build apk --release
# APK: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📁 ফাইল স্ট্রাকচার

```
lib/
├── main.dart
├── models/
│   └── snake_model.dart       # Position, Direction, FoodItem
├── utils/
│   └── game_controller.dart   # সব গেম লজিক + টাইমার
├── screens/
│   ├── home_screen.dart       # হোম + স্পিড সিলেকশন
│   └── game_screen.dart       # মূল গেম স্ক্রিন
└── widgets/
    ├── game_board.dart        # CustomPainter দিয়ে বোর্ড আঁকা
    ├── dpad_controls.dart     # D-Pad বাটন
    └── game_over_overlay.dart # গেম ওভার পপআপ
```

---

## 🎮 খেলার নিয়ম

১. গতি বেছে নাও → খেলা শুরু করো
২. D-Pad বা Swipe দিয়ে সাপ নিয়ন্ত্রণ করো
৩. খাবার খাও → সাপ বড় হয় + পয়েন্ট বাড়ে
৪. দেয়াল বা নিজের শরীরে লাগলে গেম শেষ!

---

## 🔧 পয়েন্ট সিস্টেম

| খাবার | পয়েন্ট |
|-------|--------|
| 🍎🍊 | ১০ × লেভেল |
| 🍇🍓 | ১৫ × লেভেল |
| 🌟   | ৩০ × লেভেল |

Made with ❤️ for Kids | Flutter 3.x
