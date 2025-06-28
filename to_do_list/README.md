# 📱 Flutter To-Do List App

A modern, feature-rich task management application built with Flutter. Organize your daily tasks with priority levels, date/time scheduling, and efficient task categorization.

## ✨ Features

- **📝 Task Management**: Create, edit, and delete tasks with ease
- **🎯 Priority Levels**: Set task priorities (High, Normal, Low) for better organization
- **📅 Date & Time Scheduling**: Schedule tasks with specific dates and times
- **📂 Task Categories**: 
  - New Tasks (Pending)
  - Completed Tasks (Done)
  - Archived Tasks
- **💾 Local Storage**: All data is stored locally using Sqflite database
- **🎨 Modern UI**: Clean and intuitive user interface with smooth animations
- **📱 Cross-Platform**: Runs on Android, iOS, Windows, macOS, Linux, and Web



## 🏗️ Project Structure

```
lib/
├── main.dart                 # Entry point of the application
├── layout/
│   └── home_layout.dart     # Main layout with bottom navigation
├── modules/
│   ├── new_tasks/           # New tasks screen
│   ├── done_tasks/          # Completed tasks screen
│   └── archived_tasks/      # Archived tasks screen
└── shared/
    ├── components.dart      # Reusable UI components
    ├── constants.dart       # App constants
    ├── bloc_observer.dart   # Bloc state observer
    └── cubit/
        ├── cubit.dart       # App state management
        └── states.dart      # App states definitions
```

