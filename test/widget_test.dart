import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rto_crew/app.dart';
import 'package:rto_crew/data/crew_store.dart';
import 'package:rto_crew/models/crew_task.dart';
import 'package:rto_crew/screens/create_task_screen.dart';
import 'package:rto_crew/screens/crew_home_screen.dart';
import 'package:rto_crew/widgets/crew_widgets.dart';
import 'package:rto_crew/screens/welcome_screen.dart';
import 'package:rto_crew/theme/app_theme.dart';

void main() {
  test(
    'accepting a task updates availability and prevents duplicate joins',
    () {
      final store = CrewStore();
      final task = store.tasks[1];
      store.accept(task);
      store.accept(task);
      expect(task.volunteersNeeded, 1);
      expect(task.assignees, ['Marcia']);
      store.updateStatus(task, TaskStatus.onMyWay);
      expect(task.statusLabel, 'On my way');
      store.updateStatus(task, TaskStatus.completed);
      expect(store.completedCount, 1);
      store.dispose();
    },
  );

  testWidgets('create task validates and saves local form data', (
    tester,
  ) async {
    final store = CrewStore();
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => CreateTaskScreen(store: store),
                ),
              ),
              child: const Text('Open form'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Task title'),
      'Refill sunscreen',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'What needs to be done?'),
      'Stock the crew station.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Location'),
      'Volunteer HQ',
    );
    await tester.ensureVisible(find.text('Start time'));
    await tester.tap(find.text('Start time'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    final submit = find.widgetWithText(FilledButton, 'Create Task');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(store.tasks.first.title, 'Refill sunscreen');
    expect(store.tasks.first.volunteersNeeded, 2);
    expect(store.createdCount, 1);
    expect(find.text('Open form'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('welcome fits iPhone viewports without scrolling', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = CrewStore();
    addTearDown(store.dispose);
    for (final size in [
      const Size(390, 844),
      const Size(402, 874),
      const Size(430, 932),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(padding: const EdgeInsets.only(top: 62, bottom: 34)),
            child: child!,
          ),
          home: WelcomeScreen(store: store),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      expect(scrollable.position.maxScrollExtent, 0);
      for (final label in ['RTO STAFF', 'VOLUNTEER', 'JUST ¾ OF IT.']) {
        final bounds = tester.getRect(find.text(label));
        expect(bounds.top, greaterThanOrEqualTo(62));
        expect(bounds.bottom, lessThanOrEqualTo(size.height - 34));
      }
      for (final button in tester.widgetList<FilledButton>(
        find.byType(FilledButton),
      )) {
        expect(
          tester.getSize(find.byWidget(button)).height,
          greaterThanOrEqualTo(52),
        );
      }
    }
  });

  testWidgets('entry scrolls on small screens with larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = CrewStore();
    addTearDown(store.dispose);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.5)),
          child: child!,
        ),
        home: WelcomeScreen(store: store),
      ),
    );
    await tester.ensureVisible(find.text('VOLUNTEER'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('JUST ¾ OF IT.'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('staff can enter dashboard and open create task', (tester) async {
    tester.view.resetPhysicalSize();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const RtoCrewApp());
    await tester.ensureVisible(find.text('RTO STAFF'));
    await tester.tap(find.text('RTO STAFF'));
    await tester.pumpAndSettle();
    expect(find.text('Good morning, Lindsey'), findsOneWidget);
    await tester.tap(find.text('WHAT NEEDS TO GET DONE?'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, 'Task title'), findsOneWidget);
    expect(find.text('What needs to be done?'), findsOneWidget);
  });

  testWidgets('dashboard fits iPhones and handles long task names', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = CrewStore();
    addTearDown(store.dispose);
    store.tasks.insert(
      0,
      CrewTask(
        id: 'layout-check',
        title: 'Prepare the conservation village and shoreline volunteer welcome stations',
        description: '',
        location:
            'Conservation Village entrance beside the main festival stage',
        time: '10:00 AM – 12:00 PM',
        volunteersNeeded: 3,
        highPriority: true,
        assignees: ['Alexandria', 'Christopher', 'Taylor'],
      ),
    );
    for (final size in [
      const Size(320, 568),
      const Size(390, 844),
      const Size(402, 874),
      const Size(430, 932),
    ]) {
      for (final scale in [1.0, 1.5]) {
        tester.view.physicalSize = size;
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: const EdgeInsets.only(top: 59, bottom: 34),
                textScaler: TextScaler.linear(scale),
              ),
              child: child!,
            ),
            home: CrewHomeScreen(key: UniqueKey(), store: store, staff: true),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(OceanHeader)).height, 80);
        if (size.width >= 390 && scale == 1) {
          final navTop = tester.getTopLeft(find.byType(NavigationBar)).dy;
          expect(
            tester.getBottomLeft(find.text('Needs Attention')).dy,
            lessThan(navTop),
          );
          expect(
            tester.getTopLeft(find.byType(DashboardTaskCard).first).dy,
            lessThan(navTop - 40),
          );
          for (final label in ['OPEN', 'ACTIVE', 'IN PROGRESS', 'DONE TODAY']) {
            expect(
              tester.getBottomLeft(find.text(label).first).dy,
              lessThan(navTop),
            );
          }
        }
        await tester.scrollUntilVisible(
          find.text('Recently Assigned'),
          180,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('volunteer can mark a task on the way and complete it', (
    tester,
  ) async {
    tester.view.resetPhysicalSize();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const RtoCrewApp());
    await tester.ensureVisible(find.text('VOLUNTEER'));
    await tester.tap(find.text('VOLUNTEER'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text("I'm On My Way"), 220);
    await tester.ensureVisible(find.text("I'm On My Way"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("I'm On My Way"));
    await tester.pumpAndSettle();
    expect(find.text('ON MY WAY'), findsOneWidget);
    await tester.ensureVisible(find.text('Mark Complete'));
    await tester.tap(find.text('Mark Complete'));
    await tester.pumpAndSettle();
    expect(find.text('COMPLETED'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
