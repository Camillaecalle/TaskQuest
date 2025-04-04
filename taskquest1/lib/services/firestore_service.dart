import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTask(String uid, String task) async {
    try {
      await _db.collection('tasks').add({
        'userId': uid,
        'task': task,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Task added successfully");
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getTasks(String uid) {
    return _db
        .collection('tasks')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList());
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete();
      print("Task deleted successfully");
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
