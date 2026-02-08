import 'package:flutter/material.dart';
import 'utils/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase(); // 初始化 Firebase（关联 MyLearningApp）
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyLearningApp',
      home: Scaffold(
        appBar: AppBar(title: const Text('MyLearningApp 学习记录')),
        body: const Center(child: Text('后端逻辑已集成！')),
      ),
    );
  }
}