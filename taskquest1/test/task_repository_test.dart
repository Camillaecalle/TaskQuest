import 'package:flutter_test/flutter_test.dart';

//

void main() {
  test('sample task object contains correct values', () {
    final fakeTask = {
      'id': 123,
      'task': 'Sample Task',
      'dueDate': DateTime.now().toIso8601String(),
      'priority': 'Medium',
      'completed': false,
      'notes': '',
    };

    expect(fakeTask['task'], 'Sample Task');
    expect(fakeTask['priority'], 'Medium');
    expect(fakeTask['completed'], isFalse);
  });
}
