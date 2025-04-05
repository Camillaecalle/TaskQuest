import 'package:flutter/material.dart';
import 'components/const/colors.dart';
import 'components/button_widget.dart';

class TaskManagerPage extends StatefulWidget {
  @override
  _TaskManagerPageState createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  int? _editingIndex;

  void _addOrEditTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          _tasks[_editingIndex!] = text;
          _editingIndex = null;
        } else {
          _tasks.add(text);
        }
        _taskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      if (_editingIndex == index) {
        _taskController.clear();
        _editingIndex = null;
      }
    });
  }

  void _editTask(int index) {
    setState(() {
      _taskController.text = _tasks[index];
      _editingIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Enter a task',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryGreen),
                ),
              ),
            ),
            SizedBox(height: 12),
            ButtonWidget(
              text: _editingIndex == null ? 'Add Task' : 'Update Task',
              onPressed: _addOrEditTask,
            ),
            SizedBox(height: 20),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text('No tasks added.'))
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(_tasks[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: secondaryGreen),
                          onPressed: () => _editTask(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
