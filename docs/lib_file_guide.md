# RTO Crew — Application File Guide

Inventory of all 10 Dart application files under lib/, including subdirectories. Based on the local source reviewed October 31, 2026.

RTO Crew is a Flutter prototype for Rock The Ocean volunteer operations at Tortuga Music Festival. Task data is shared in memory during the current app session and resets when the app restarts. The current implementation has no authentication or backend persistence.

## Application startup and data

### lib/main.dart

**Purpose:** Application entry point.

Defines main(), which starts Flutter by calling runApp(const RtoCrewApp()).

**Key definitions:** main

### lib/app.dart

**Purpose:** Root application configuration and shared store lifecycle.

Defines RtoCrewApp, creates one CrewStore for the app session, applies buildTheme(), and opens WelcomeScreen. Disposes the store when the root widget is removed.

**Key definitions:** RtoCrewApp; _RtoCrewAppState

### lib/models/crew_task.dart

**Purpose:** Task data structure and task status definitions.

Defines task identity, title, description, location, time, notes, priority, remaining volunteer count, status, and assignees. TaskStatus covers open, assigned, onMyWay, and completed. The isMine helper identifies tasks assigned to the sample volunteer Marcia; statusLabel supplies display text.

**Key definitions:** CrewTask; TaskStatus

### lib/data/crew_store.dart

**Purpose:** Shared, observable task state for the prototype.

Seeds five example tasks and uses ChangeNotifier to refresh listening screens. add() inserts new tasks and tracks creation count. accept() assigns Marcia, reduces remaining volunteer slots, and marks a task assigned, with checks against duplicate acceptance, no slots, or completed tasks. updateStatus() changes task progress. completedCount measures completions beyond the one initially completed sample task.

**Key definitions:** CrewStore; add(); accept(); updateStatus(); createdCount; completedCount

## Application screens

### lib/screens/welcome_screen.dart

**Purpose:** Branded welcome page and staff/volunteer experience selection.

Shows cropped regions of the welcome artwork, introductory copy, role buttons, and a custom wave footer. Adapts its layout and scrolling to screen size and text scaling. Passes the existing CrewStore and selected staff flag to CrewHomeScreen. Choosing a role is prototype navigation, rather than an authentication step.

**Key definitions:** WelcomeScreen; _ReferenceRegion; _Hero; _MainContent; _OceanFooter; _WavePainter

### lib/screens/crew_home_screen.dart

**Purpose:** Main navigation and content for both staff and volunteers.

Staff tabs provide Dashboard, Tasks, Volunteers, and Impact. Volunteer tabs provide Home, My Tasks, and Impact. Builds task lists, assignment views, dashboard summaries, volunteer participation actions, and completed-task summaries. Opens task details and task creation, and rebuilds when the store changes. Some staff totals use fixed sample baselines; they are not direct counts of the five sample tasks.

**Key definitions:** CrewHomeScreen; _CrewHomeScreenState

### lib/screens/create_task_screen.dart

**Purpose:** Task creation form used by staff navigation.

Collects title, description, location, start time, number of volunteers, priority, and optional notes. Validates required fields, a selected time, and at least one volunteer. Creates a CrewTask with a timestamp-based ID, adds it to CrewStore, closes the form, and displays confirmation. Disposes its text controllers.

**Key definitions:** CreateTaskScreen; _CreateTaskScreenState; _submit()

### lib/screens/task_detail_screen.dart

**Purpose:** Detailed task information and volunteer progress actions.

Displays status, priority, schedule, location, remaining slots, description, optional notes, and assignees. Volunteers can accept available tasks and update their own tasks to on the way or completed. Staff view the task without those volunteer actions. Shows a completion message for completed tasks and listens for store updates.

**Key definitions:** TaskDetailScreen

## Visual theme and reusable components

### lib/theme/app_theme.dart

**Purpose:** Shared colors and Material 3 theme.

Defines the navy, blue, teal, and mist palette. buildTheme() configures the color scheme, typography, scaffold background, app bars, cards, text inputs, filled buttons, and navigation bars.

**Key definitions:** CrewColors; buildTheme()

### lib/widgets/crew_widgets.dart

**Purpose:** Reusable interface components shared across screens.

OceanHeader provides the branded festival banner and a notification icon tooltip. SectionTitle renders headings and optional subtitles. StatusBadge displays task status. TaskCard presents task details with optional notes and an action widget. MetaLine pairs an icon with text. DashboardTaskCard and DashboardAssignmentCard provide compact staff task and assignment cards. These widgets display information and invoke supplied callbacks; the store owns task changes.

**Key definitions:** OceanHeader; SectionTitle; StatusBadge; TaskCard; MetaLine; DashboardTaskCard; DashboardAssignmentCard

## How the files work together

main.dart starts RtoCrewApp in app.dart. The app creates CrewStore, applies app_theme.dart, and opens WelcomeScreen. WelcomeScreen opens CrewHomeScreen with the selected role. Home navigation opens CreateTaskScreen or TaskDetailScreen. Screens use CrewTask models and shared crew_widgets.dart components; CrewStore notifications refresh listening screens.

## Other file under lib/

`lib/.DS_Store` is macOS Finder metadata. It is not application source and has no runtime role.
