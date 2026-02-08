import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// 初始化 Firebase（App 启动时调用）
Future<void> initFirebase() async {
  try {
    await Firebase.initializeApp(
      // 若本地未自动生成配置文件，需从 Firebase 控制台复制你的配置
      options: const FirebaseOptions(
        apiKey: "AIzaSyDB4bbuhkvEGuu9DO0ReXVzlVE3tg96Yxk",
        authDomain: "mylearningapp-bbb51.firebaseapp.com",
        projectId: "mylearningapp-bbb51",
        storageBucket: "mylearningapp-bbb51.firebasestorage.app",
        messagingSenderId: "749419821882",
        appId: "1:749419821882:web:872625f6a0c5bfce3aae03",
        measurementId: "G-3V9RFWCPZ9"
      ),
    );
    if (kDebugMode) {
      print("Firebase 初始化成功！关联项目：MyLearningApp");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Firebase 初始化失败：$e");
    }
  }
}

// Firestore 数据库操作示例（增删改查）
class FirestoreService {
  // 1. 添加数据（比如保存学习记录）
  Future<void> addLearningRecord(String title, String content) async {
    try {
      await FirebaseFirestore.instance
          .collection("learning_records") // 集合名（类似数据库表名）
          .add({
        "title": title,
        "content": content,
        "create_time": Timestamp.now(), // 时间戳
      });
      if (kDebugMode) {
        print("学习记录添加成功！");
      }
    } catch (e) {
      if (kDebugMode) {
        print("添加失败：$e");
      }
    }
  }

  // 2. 获取所有学习记录
  Stream<QuerySnapshot> getLearningRecords() {
    return FirebaseFirestore.instance
        .collection("learning_records")
        .orderBy("create_time", descending: true)
        .snapshots(); // 实时监听数据变化
  }

  // 3. 删除学习记录
  Future<void> deleteLearningRecord(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("learning_records")
          .doc(docId)
          .delete();
      if (kDebugMode) {
        print("记录删除成功！");
      }
    } catch (e) {
      if (kDebugMode) {
        print("删除失败：$e");
      }
    }
  }
}