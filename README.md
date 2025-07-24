# 💰 SmartWallet

**SmartWallet** is a minimal and focused expense tracker app to help users manage **daily spending, budgets, and financial goals** by recording expenses and reviewing history, built with **Flutter** and powered by **SQLite**.

---

## 🎯 Project Goal

SmartWallet is designed to help users:

- Log daily expenses quickly and easily
- Track spending across categories and time periods
- Monitor and review their financial activity over time
- Organize expenses with meaningful notes and dates
- Prepare for future features like summaries, reminders, and shared tracking

---

## 🛠️ Tech Stack

| Layer           | Tool / Package             | Purpose                            |
| --------------- | -------------------------- | ---------------------------------- |
| UI              | Flutter                    | Frontend interface                 |
| Local Storage   | `sqflite`, `path_provider` | Offline persistence via SQLite     |
| State Mgmt      | `setState`                 | MVP-friendly state updates         |
| Version Control | Git + GitHub               | Project versioning & collaboration |

---

## 🧱 Architecture

### 🔄 App Flow

1. **User opens the app** and sees a list of expenses sorted by latest
2. **User adds new expense entry** with amount, category, date, and note
3. **Expense list updates instantly** to show the newly added entry with clear formatting
4. **User deletes or edits** via swipe or long-press actions
5. **All data is stored in SQLite** and persists across app launches

### 🔧 Responsibilities

- **Flutter** handles:

  - UI rendering & user navigation
  - Form inputs, validation, and screen transitions
  - State management using `setState`
  - Displaying and updating expense entries responsively

- **SQLite(via `sqflite`)** handles :
  - Local database creation and access
  - CRUD operations: insert, fetch, update, delete expenses
  - Data persistence across sessions for offline continuity

---

## 📱 Core Features (MVP)

- **Add expense** with: **amount, category, note, and date**
- **View list** of recent expenses
- **Delete expenses** via **long press or swipe**
- **Data stored locally** using **SQLite**
- **Clean and minimal** Flutter UI
- **No sign-in required**, works fully without accounts

---

## ✨ Planned Features (Future Enhancements)

- 📊 Monthly & category-wise summaries
- 📸 Receipt scanning (OCR with ML Kit)
- 🔔 Daily reminders
- 👥 Shared/group expenses with friends
- 📁 Export data as CSV/PDF
- 🔍 Search, filter, and sort by date/category

---

## 🧭 Project Milestones

### 📦 Milestone 1: Project Setup ✅

> Initialize the app and clean base project structure

- [x] Create Flutter project
- [x] Clean boilerplate and organize folders
- [x] Set up Git repository and push initial commit

### 🏠 Milestone 2: Home Screen UI ✅

> Build the interface to display expenses

- [x] Create static UI with top bar and expense list
- [x] Build reusable `ExpenseTile` widget
- [x] Show mock expenses for layout testing

### ✍️ Milestone 3: Add Expense Form ⏳

> Add a screen to input new expense data

- [ ] Create form with fields for amount, category, note, and date
- [ ] Add form validation and navigation

### 🔄 Milestone 4: State Management ⏳

> Dynamically update the expense list

- [ ] Use `setState` to reflect newly added expenses
- [ ] Route between home screen and add expense screen

### 💾 Milestone 5: SQLite Integration ⏳

> Store expenses persistently on the device

- [ ] Add and configure `sqflite` and `path_provider`
- [ ] Create `database_helper.dart` to handle CRUD operations
- [ ] Load and display saved expenses at startup

### 🗑️ Milestone 6: Deletion Functionality ⏳

> Allow users to manage and delete entries

- [ ] Swipe to delete an expense
- [ ] Long-press to show delete confirmation

### 🎨 Milestone 7: UI Polish ⏳

> Improve user interface for better UX

- [ ] Apply consistent spacing, fonts, and padding
- [ ] Finalize app theme with clean and minimal look

### 🔮 Milestone 8: Future-Ready Setup ⏳

> Lay the groundwork for upcoming features

- [ ] Plan DB schema to support summaries and exports
- [ ] Draft UI concepts for receipt OCR and shared tracking

---

## 🧠 Learning Goals

- 🛠️ Build a production-ready UI using Flutter widgets
- 💾 Use SQLite for persistent local storage
- 🧱 Apply a clean and maintainable project architecture
- ⏰ Format and manipulate date/time effectively using Dart
- 🚀 Prepare for feature scaling with a future-proof codebase

---

## 📂 Folder Structure (Planned)

```txt
lib/
├── db/             # SQLite database helper and setup
├── models/         # Data models
├── screens/        # UI screens (Home, Add Expense)
├── widgets/        # Reusable UI components
└── utils/          # Helpers
```

---

## 🧾 License

MIT © 2025 Subhan Shaikh ([@subhan-0073](https://github.com/subhan-0073))

---

## 📬 Contributions

Contributions are currently limited as this is a **learning-focused solo project**. Feel free to fork or follow along!

---

## 📌 Status

**IN DEVELOPMENT**: Follow the milestones for progress updates!
