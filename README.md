# RTO Crew

A local Flutter prototype for Rock The Ocean volunteer operations at Tortuga Music Festival.

## Run

From this directory:

    flutter run -d <device-id>

Use `flutter devices` to find an iPhone or simulator. Physical iPhone builds require Xcode signing configured for your Apple development team.

## Prototype

Choose **RTO Staff** or **Volunteer** on the opening screen. Use the back arrow to switch experiences. Staff can browse tasks, view assignments, and create tasks. Volunteers can accept tasks, mark themselves on the way, and complete tasks.

All data lives in memory and is shared between experiences during the current app session. Restarting the app resets the sample data. Dashboard totals begin at the requested festival mock totals (12 / 28 / 6 / 17); the task list is a representative sample. Creation and task progress update the corresponding totals.

## Organization

- `lib/screens/`: welcome, staff/volunteer navigation, task creation and details
- `lib/widgets/`: reusable coastal header, cards, status and metadata
- `lib/models/`: task model and statuses
- `lib/data/`: observable in-memory mock store
- `lib/theme/`: colors and Material theme
- `lib/app.dart`: app and store lifecycle
- `lib/main.dart`: entry point

## Checks

    flutter analyze
    flutter test

No authentication, network calls, backend services, or additional packages were added.
