import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'components/const/colors.dart';
import 'components/button_widget.dart';

class TaskManagerPage extends StatefulWidget {
  @override
  _TaskManagerPageState createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDueDate;
  String _selectedPriority = 'Medium';
  int? _editingIndex;
  double _progress = 0.0;
  int _currentIndex = 0;

  // Function to calculate the progress based on completed tasks
  void _calculateProgress() {
    if (_tasks.isNotEmpty) {
      int completedTasks = _tasks
          .where((task) => task['completed'] == true)
          .length;
      setState(() {
        _progress = completedTasks / _tasks.length;
      });
    } else {
      setState(() {
        _progress = 0.0;
      });
    }
  }

  void _openTaskDialog({int? index}) {
    if (index != null) {
      _taskController.text = _tasks[index]['task'];
      _selectedDueDate = _tasks[index]['dueDate'];
      _selectedPriority = _tasks[index]['priority'];
      _editingIndex = index;
    } else {
      _taskController.clear();
      _selectedDueDate = null;
      _selectedPriority = 'Medium';
      _editingIndex = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(_editingIndex == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Enter a task',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              ListTile(
                title: Text(
                  _selectedDueDate == null
                      ? 'Select Due Date'
                      : 'Due Date: ${DateFormat('MMM dd, yyyy').format(
                      _selectedDueDate!)}',
                ),
                trailing: Icon(Icons.calendar_today, color: primaryGreen),
                onTap: _pickDueDate,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Select Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['High', 'Medium', 'Low'].map((String priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              SizedBox(height: 12),
              ButtonWidget(
                text: _editingIndex == null ? 'Add Task' : 'Update Task',
                onPressed: _addOrEditTask,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  void _addOrEditTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty && _selectedDueDate != null) {
      setState(() {
        if (_editingIndex != null) {
          _tasks[_editingIndex!] = {
            'task': text,
            'dueDate': _selectedDueDate!,
            'priority': _selectedPriority,
            'completed': false,
          };
        } else {
          _tasks.add({
            'task': text,
            'dueDate': _selectedDueDate!,
            'priority': _selectedPriority,
            'completed': false,
          });
        }
        _sortTasks();
        _calculateProgress(); // Update progress after adding/editing tasks
      });
      _taskController.clear();
      _selectedDueDate = null;
      _selectedPriority = 'Medium';
      _editingIndex = null;
      Navigator.pop(context); // Close the dialog
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _calculateProgress(); // Recalculate progress when a task is deleted
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
      _calculateProgress(); // Update progress when a task's completion status changes
    });
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      int priorityComparison = priorityOrder[a['priority']]!.compareTo(
          priorityOrder[b['priority']]!);
      if (priorityComparison == 0) {
        return a['dueDate'].compareTo(b['dueDate']);
      }
      return priorityComparison;
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Pages for other tabs (empty for now)
  Widget _buildTabContent(int index) {
    switch (index) {
      case 1:
        return Center(child: Text('Calendar View - Empty for now.'));
      case 2:
        return Center(child: Text('Completed Tasks - Empty for now.'));
      case 3:
        return Center(child: Text('Progress Overview - Empty for now.'));
      case 4:
        return Center(child: Text('Settings - Empty for now.'));
      default:
        return _buildTaskList();
    }
  }

  Widget _buildTaskList() {
    return Column(
      children: [
        // Progress Bar Section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                // Makes the progress bar take up 80% of the screen width
                height: 20,
                // Set the height for the progress bar
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // Round the corners of the progress bar
                  color: Colors
                      .grey[300], // Background color for the progress bar
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // Round the inner progress bar as well
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.transparent,
                    // Make the background transparent to show rounded corners
                    valueColor: AlwaysStoppedAnimation<Color>(
                        primaryGreen), // Green color for the progress bar
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Progress: ${((_progress) * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Task List Section
        _tasks.isEmpty
            ? Center(child: Text('No tasks added.'))
            : Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) =>
                Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(_tasks[index]['priority']),
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(_tasks[index]['task']),
                    subtitle: Text(
                      'Due: ${DateFormat('MMM dd, yyyy').format(
                          _tasks[index]['dueDate'])}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: secondaryGreen),
                          onPressed: () => _openTaskDialog(index: index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(index),
                        ),
                        Checkbox(
                          value: _tasks[index]['completed'],
                          onChanged: (bool? value) {
                            _toggleTaskCompletion(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: _buildTabContent(_currentIndex),
      // Change the body based on the selected tab
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _openTaskDialog(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildNavBarItemIcon(0, Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarItemIcon(1, Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarItemIcon(2, Icons.check_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarItemIcon(3, Icons.leaderboard),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavBarItemIcon(4, Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItemIcon(int index, IconData iconData) {
    bool isSelected = _currentIndex == index;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? primaryGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(
        iconData,
        color: isSelected
            ? Colors.white
            : primaryGreen, // Change icon color to white if selected
      ),
    );
  }
}
