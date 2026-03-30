import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reminder_and_stopwatch/features/theme/presentation/controllers/theme_controller.dart';
import 'package:reminder_and_stopwatch/features/timer/presentation/screens/timer_page.dart';

import 'features/stopwatch/presentation/screens/stopwatch_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final themeController = Get.find<ThemeController>();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(()
      => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: themeController.isDark.value
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: .fromSeed(seedColor: Colors.deepPurple,
            brightness: Brightness.light),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0E1A2B),
          colorScheme: .fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark
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

  final pages = [
    StopwatchPage(),
    TimerPage()
  ];
  final themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
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
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() {
            index = i;
          }),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.timer),label: "Stopwatch"),
            BottomNavigationBarItem(icon: Icon(Icons.hourglass_bottom),label: "Timer"),
          ],
        ),
      ),
    );
  }
}
