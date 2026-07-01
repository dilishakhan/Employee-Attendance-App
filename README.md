# Employee Attendance Management System

A Flutter-based Employee Attendance Management System that enables employees to manage attendance and leave requests while providing administrators with tools to monitor employees, attendance records, and leave approvals. The project uses Supabase as the backend for authentication and database management.

---

# Project Overview

This application provides a simple and efficient way to manage employee attendance digitally. Employees can check in/out, view attendance history, request leave, and manage their profile. Administrators can monitor employees, view attendance reports, approve/reject leave requests, and access dashboard statistics.

---

# Tech Stack

## Frontend
- Flutter
- Dart
- Riverpod (State Management)
- Go Router (Navigation)
- Google Fonts

## Backend
- Supabase Authentication
- Supabase PostgreSQL Database
- Row Level Security (RLS)

## Architecture
- Feature-first folder structure
- Repository Pattern
- Provider-based State Management

---

# Features Implemented

## Authentication
- Login using Supabase Authentication
- Role-based login (Admin & Employee)
- Persistent login session
- Secure logout

## Employee Features
- Daily Check-In
- Daily Check-Out
- Working Hours Calculation
- Attendance History
- Leave Request Submission
- Leave Status Tracking
- Profile Management
- Update Name
- Update Phone Number
- View Department
- View Designation

## Admin Features
- Dashboard Statistics
- Employee Management
- Attendance Monitoring
- Leave Request Approval/Rejection
- Registered Employee Count
- Attendance Count
- Leave Count

## Search & Filters
- Search employees by name
- Filter attendance by date
- Filter leave requests by status

## UI Improvements
- Loading Indicators
- Empty States
- Error States
- Retry Actions
- Form Validation
- User-friendly Error Messages

## Code Quality
- Reusable Widgets
- Repository Pattern
- Riverpod Providers
- Clean Folder Structure
- Code Refactoring
- Comments for Better Readability

---

# Setup Instructions

## 1. Clone the Repository

```bash
git clone <repository-url>
```

## 2. Navigate to the Project

```bash
cd employee_attendance_app
```

## 3. Install Dependencies

```bash
flutter pub get
```

## 4. Configure Supabase

Update the Supabase URL and Anon Key inside:

```
lib/supabase_options.dart
```

---

## 5. Run the Application

```bash
flutter run
```

---

# Database

Supabase PostgreSQL is used for storing:

- Users
- Attendance Records
- Leave Requests
- Employee Profiles

Authentication is handled using Supabase Auth with Row Level Security (RLS) enabled.

---

# Future Improvements

- Profile Picture Upload
- Attendance Reports Export
- Push Notifications
- Biometric Authentication
- Calendar View
- Admin Analytics Dashboard
- Dark Mode Support

---


