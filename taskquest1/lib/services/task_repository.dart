import 'package:cloud_firestore/cloud_firestore.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveTask(String userId, Map<String, dynamic> task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task['id'].toString())
        .set(task);
  }

  Future<List<Map<String, dynamic>>> loadTasks(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['dueDate'] = DateTime.parse(data['dueDate']); // Convert from string
      return data;
    }).toList();
  }
}
