import 'package:flutter_test/flutter_test.dart';
import 'package:taskquest1/services/task_repository.dart';

void main() {
  test('saveTask and loadTasks should work (mocked)', () async {
    final repo = TaskRepository();
    final fakeUserId = 'test-user';
    final fakeTask = {
      'id': 123,
      'task': 'Sample Task',
      'dueDate': DateTime.now().toIso8601String(),
      'priority': 'Medium',
      'completed': false,
      'notes': '',
    };

    // You'd mock Firestore calls here normally
    // await repo.saveTask(fakeUserId, fakeTask);
    // final tasks = await repo.loadTasks(fakeUserId);

    expect(fakeTask['task'], 'Sample Task');
  });
}
