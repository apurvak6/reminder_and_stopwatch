import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_and_stopwatch/core/services/notification_service.dart';
import 'package:reminder_and_stopwatch/features/reminder/data/datasource/reminder_local_datasource.dart';
import 'package:reminder_and_stopwatch/features/reminder/data/repository/reminder_repository_impl.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/add_reminder.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/delete_reminder.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/get_reminders.dart';
import 'package:reminder_and_stopwatch/features/reminder/domain/usecases/sort_reminders.dart';
import 'package:reminder_and_stopwatch/features/reminder/presentation/controllers/reminder_controller.dart';
import 'package:reminder_and_stopwatch/features/reminder/presentation/screens/reminder_page.dart';
import 'package:reminder_and_stopwatch/core/theme/theme_controller.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/data/repository_impl/stopwatch_repository_impl.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/domain/repositories/stopwatch_repository.dart';
import 'package:reminder_and_stopwatch/features/stopwatch/presentation/controllers/stopwatch_controller.dart';
import 'package:reminder_and_stopwatch/features/timer/data/repository_impl/timer_repository_impl.dart';
import 'package:reminder_and_stopwatch/features/timer/domain/repositories/timer_repository.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/controllers/timer_controller.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/screens/timer_page.dart';

import 'features/reminder/data/model/reminder_model.dart';
import 'features/reminder/data/repository/notification_repository_impl.dart';
import 'features/stopwatch/presentation/screens/stopwatch_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ReminderModelAdapter());
  await Hive.openBox<ReminderModel>('reminders');

  await NotificationService.init();

  repositoryInitialization();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeController = Get.find<ThemeController>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reminder & Stopwatch App',
        themeMode: themeController.isDark.value
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: .fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0E1A2B),
          colorScheme: .fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        home: const MyHomePage(title: 'StopWatch'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  final pages = [StopwatchPage(), TimerPage(), ReminderPage()];
  final themeController = Get.find<ThemeController>();

  String title = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: getTitle(),
          elevation: 10,
          actions: [
            Obx(
              () => IconButton(
                icon: Tooltip(
                  message: "Toggle Theme",
                  child: Icon(
                    themeController.isDark.value
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                  ),
                ),
                onPressed: themeController.toggleTheme,
              ),
            ),
          ],
        ),
        body: Center(child: pages[index]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() {
            index = i;
          }),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: "Stopwatch",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_bottom),
              label: "Timer",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm_add_outlined),
              label: "Reminder",
            ),
          ],
        ),
      ),
    );
  }

  Widget getTitle() {
    setState(() {
      if (index == 0) {
        title = "Stopwatch";
      } else if (index == 1) {
        title = "Timer";
      } else if (index == 2) {
        title = "Reminders";
      } else {
        title = widget.title;
      }
    });

    return Text(title);
  }
}

void repositoryInitialization() {
  /// stopwatch dependency
  final repo = StopwatchRepositoryImpl();
  Get.put<StopwatchRepository>(repo);
  Get.put(StopwatchController(repo));

  ///reminder dependency
  final ds = ReminderLocalDatasource();
  final reminderRepo = ReminderRepositoryImpl(ds);
  final notif = NotificationRepositoryImpl();

  Get.lazyPut(() => ReminderController(
    addReminder: AddReminderUsecase(reminderRepo),
     deleteReminder: DeleteReminderUsecase(reminderRepo),
     getReminders: GetRemindersUsecase(reminderRepo),
     sortReminders: SortReminders(),
     notificationRepository: notif,
  ));

  ///timer dependency
  final timerRepo = TimerRepositoryImpl();
  Get.put<TimerRepository>(timerRepo);
  Get.put(TimerController(timerRepo));

  /// theme controller
  Get.put(ThemeController());
}
