import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase(); // 初始化 Firebase（已替换真实配置）
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyLearningApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LearningRecordPage(), // 跳转到测试页面
    );
  }
}

// 测试页面：包含添加/展示学习记录的功能
class LearningRecordPage extends StatefulWidget {
  const LearningRecordPage({super.key});

  @override
  State<LearningRecordPage> createState() => _LearningRecordPageState();
}

class _LearningRecordPageState extends State<LearningRecordPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // 点击按钮添加学习记录
  void _addRecord() {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    if (title.isNotEmpty) {
      _firestoreService.addLearningRecord(title, content);
      // 清空输入框
      _titleController.clear();
      _contentController.clear();
      // 提示添加成功
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('学习记录添加成功！')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('标题不能为空！')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyLearningApp 测试')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 输入框：填写学习记录标题和内容
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '学习记录标题',
                hintText: '比如：Flutter 集成 Firebase',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '学习记录内容',
                hintText: '比如：完成了 Firebase 初始化',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // 添加记录按钮
            ElevatedButton(
              onPressed: _addRecord,
              child: const Text('添加学习记录'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            const Text('已添加的学习记录：', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // 实时展示数据库中的学习记录
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getLearningRecords(), // 监听数据库变化
                builder: (context, snapshot) {
                  // 处理加载/错误状态
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('加载失败：${snapshot.error}'));
                  }
                  // 获取数据列表
                  final records = snapshot.data?.docs ?? [];
                  if (records.isEmpty) {
                    return const Center(child: Text('暂无学习记录，点击按钮添加吧！'));
                  }
                  // 展示记录列表
                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      var record = records[index];
                      Map<String, dynamic> data = record.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['title'] ?? '无标题'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['content'] ?? '无内容'),
                            Text(
                              '添加时间：${(data['create_time'] as Timestamp).toDate().toString()}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // 删除记录
                            _firestoreService.deleteLearningRecord(record.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}