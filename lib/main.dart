import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/view/screens/add_task_screen.dart';
import 'package:todo_app/view/screens/home_screen.dart';
import 'package:todo_app/view/screens/profile_screen.dart';

// تعريف كلاس المسارات عشان ننظم التنقل بين الشاشات بسهولة
class AppRoutes {
  static const String home = '/';
  static const String addTask = '/add-task';
  static const String profile = '/profile';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('User');
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      // تحديد الشاشة الافتراضية عند فتح التطبيق
      initialRoute: AppRoutes.profile,
      routes: {
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.addTask: (context) => const AddTaskScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}