# TaskFlow — Mini Task Manager

Full-stack task management application with a **Laravel 12 REST API** backend and a modern **Flutter 3.29** frontend client.

---

## 🚀 Features

- **Full CRUD Support**: View, create, edit, mark complete, and delete tasks.
- **Real-Time Workspace Dashboard**: Dynamic stats card showing pending tasks, completion ratio, and circular progress graphic.
- **Search & Filters**: Real-time keyword search across task titles and descriptions with category filter chips (All / Pending / Completed).
- **Responsive Modern UI**: Built with Material 3, Google Fonts (*Plus Jakarta Sans*), animated completion states, and overdue task alerts.
- **Robust Error Handling**: Dedicated loading spinners, empty-state illustrations, and network retry handling.
- **Full Test Coverage**: Automated PHPUnit feature test suite (17 tests) and Flutter widget tests.

---

## 🛠 Tech Stack

- **Backend**: PHP 8.2, Laravel 12, Eloquent ORM, MySQL/MariaDB (XAMPP)
- **Frontend**: Flutter 3.29 (Dart 3.7), Material 3, Google Fonts, Http
- **Testing**: PHPUnit (in-memory SQLite), Flutter Test

---

## 📁 Repository Structure

```text
├── task_manager_api/      # Laravel 12 REST API backend
├── task_manager_app/      # Flutter 3.29 frontend client
├── guide.txt              # Project specifications & technical rubric
└── PROJECT_EXPLANATION.txt # Detailed architecture guide & interview talking points
```

---

## ⚡ Quick Start

### 1. Database Setup
Ensure MySQL is running in XAMPP and create the database:
```sql
CREATE DATABASE IF NOT EXISTS task_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. Run Backend (Laravel API)
```bash
cd task_manager_api
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8000
```
API will be accessible at: `http://127.0.0.1:8000/api`

### 3. Run Frontend (Flutter)
```bash
cd task_manager_app
flutter pub get
flutter run -d chrome
```
*(Or target `windows` / Android emulator)*

---

## 🧪 Testing

- **Backend Feature Tests**:
  ```bash
  cd task_manager_api
  php artisan test
  ```
- **Frontend Widget Tests**:
  ```bash
  cd task_manager_app
  flutter test
  ```
