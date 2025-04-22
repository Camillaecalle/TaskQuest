// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For formatting the date
// import 'components/const/colors.dart';
// import 'components/button_widget.dart';
// import 'calendar_page.dart';
// import 'leaderboard_page.dart';
// import 'settings_page.dart';
//
// class TaskManagerPage extends StatefulWidget {
//   @override
//   _TaskManagerPageState createState() => _TaskManagerPageState();
// }
//
// List<Map<String, dynamic>> _highPriorityTasks = [];
// List<Map<String, dynamic>> _mediumPriorityTasks = [];
// List<Map<String, dynamic>> _lowPriorityTasks = [];
//
// class _TaskManagerPageState extends State<TaskManagerPage> {
//   final List<Map<String, dynamic>> _completedTasks = [];
//   final List<Map<String, dynamic>> _tasks = [];
//   final TextEditingController _taskController = TextEditingController();
//   final TextEditingController _taskNotesController = TextEditingController();
//
//   String _sortOrder = 'Due Date'; // or 'Recently Added'
//
//   List<Map<String, dynamic>> _getSortedTasks() {
//     List<Map<String, dynamic>> sortedTasks = [..._tasks];
//     if (_sortOrder == 'Due Date') {
//       sortedTasks.sort((a, b) => a['dueDate'].compareTo(b['dueDate']));
//     } else {
//       sortedTasks.sort((a, b) => b['id'].compareTo(a['id'])); // Recently added
//     }
//     return sortedTasks;
//   }
//
//   DateTime? _selectedDueDate;
//   String _selectedPriority = 'Medium';
//   int? _editingIndex;
//   double _progress = 0.0;
//   int _currentIndex = 0;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   // Function to calculate the progress based on completed tasks
//   void _calculateProgress() {
//     // Calculate the number of completed tasks
//     int completedCount = _completedTasks.length;
//
//     // Total tasks count (both completed and uncompleted)
//     int totalCount = _tasks.length + _completedTasks.length;
//
//     // Calculate the progress percentage
//     if (totalCount == 0) {
//       _progress = 0.0; // If no tasks, set progress to 0
//     } else {
//       _progress = completedCount /
//           totalCount; // Progress as the ratio of completed tasks to total tasks
//     }
//
//     // Ensure the progress bar reflects the updated value
//     setState(() {});
//   }
//
//   void _openTaskDialog({int? index}) {
//     if (index != null) {
//       _taskController.text = _tasks[index]['task'];
//       _selectedDueDate = _tasks[index]['dueDate'];
//       _selectedPriority = _tasks[index]['priority'];
//       _editingIndex = index;
//       final task = _tasks[index];
//       _taskNotesController.text = task['notes'] ?? '';
//     } else {
//       _taskController.clear();
//       _taskNotesController.clear();
//       _selectedDueDate = null;
//       _selectedPriority = 'Medium';
//       _editingIndex = null;
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               title: Text(_editingIndex == null ? 'Add Task' : 'Edit Task'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _taskController,
//                     decoration: InputDecoration(
//                       labelText: 'Enter a task',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                   ListTile(
//                     title: Text(
//                       _selectedDueDate == null
//                           ? 'Select Due Date'
//                           : 'Due Date: ${DateFormat('MMM dd, yyyy').format(_selectedDueDate!)}',
//                     ),
//                     trailing: Icon(Icons.calendar_today, color: primaryGreen),
//                     onTap: _pickDueDate,
//                   ),
//                   SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _selectedPriority,
//                     decoration: InputDecoration(
//                       labelText: 'Select Priority',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: ['High', 'Medium', 'Low'].map((String priority) {
//                       return DropdownMenuItem(
//                         value: priority,
//                         child: Text(priority),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedPriority = value!;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 12),
//                   ButtonWidget(
//                     text: _editingIndex == null ? 'Add Task' : 'Update Task',
//                     onPressed: _addOrEditTask,
//                   ),
//                   TextField(
//                     controller: _taskNotesController,
//                     decoration: InputDecoration(
//                       labelText: 'Notes',
//                       hintText: 'Add any details...',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 3,
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildPrioritySection(
//       String title, Color color, List<Map<String, dynamic>> tasks) {
//     final filteredTasks = tasks.where((task) => !task['completed']).toList();
//
//     if (filteredTasks.isEmpty)
//       return SizedBox.shrink(); // Hide if no tasks remain
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           ...filteredTasks.map((task) => _buildTaskCard(task)).toList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTaskCard(Map<String, dynamic> task) {
//     final int index = _tasks.indexOf(task);
//     return Card(
//       child: ListTile(
//         title: Row(
//           children: [
//             Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(
//                 color: _getPriorityColor(task['priority']),
//                 shape: BoxShape.circle,
//               ),
//             ),
//             SizedBox(width: 8),
//             Text(task['task']),
//           ],
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Due: ${DateFormat('MMM dd, yyyy').format(task['dueDate'])}'),
//             if (task['notes'] != null && task['notes'].isNotEmpty)
//               Text('Notes: ${task['notes']}'),
//           ],
//         ),
//         leading: Checkbox(
//           value: task['completed'],
//           onChanged: (_) => _toggleTaskCompletion(index),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(Icons.edit, color: Colors.green),
//               onPressed: () => _editTask(index),
//             ),
//             IconButton(
//               icon: Icon(Icons.delete, color: Colors.red),
//               onPressed: () => _deleteTask(index),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _pickDueDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDueDate = pickedDate;
//       });
//     }
//   }
//
//   void _groupTasksByPriority() {
//     _highPriorityTasks =
//         _tasks.where((task) => task['priority'] == 'High').toList();
//     _mediumPriorityTasks =
//         _tasks.where((task) => task['priority'] == 'Medium').toList();
//     _lowPriorityTasks =
//         _tasks.where((task) => task['priority'] == 'Low').toList();
//   }
//
//   void _addOrEditTask() {
//     final text = _taskController.text.trim();
//     if (text.isNotEmpty && _selectedDueDate != null) {
//       setState(() {
//         final taskId = DateTime.now()
//             .millisecondsSinceEpoch; // Generate a unique ID (timestamp)
//         if (_editingIndex != null) {
//           _tasks[_editingIndex!] = {
//             'id': taskId,
//             'task': text,
//             'dueDate': _selectedDueDate!,
//             'priority': _selectedPriority,
//             'completed': false,
//             'notes': _taskNotesController.text.trim(),
//           };
//         } else {
//           _tasks.add({
//             'id': taskId,
//             'task': text,
//             'dueDate': _selectedDueDate!,
//             'priority': _selectedPriority,
//             'completed': false,
//             'notes': _taskNotesController.text.trim(), // new field
//           });
//         }
//         _sortTasks();
//         _groupTasksByPriority();
//         _calculateProgress(); // Update progress after adding/editing tasks
//       });
//       _taskController.clear();
//       _taskNotesController.clear();
//       _selectedDueDate = null;
//       _selectedPriority = 'Medium';
//       _editingIndex = null;
//       Navigator.pop(context); // Close the dialog
//     }
//   }
//
//   void _deleteTask(int index) {
//     setState(() {
//       _tasks.removeAt(index);
//       _groupTasksByPriority();
//       _calculateProgress(); // Recalculate progress when a task is deleted
//     });
//   }
//
//   void _toggleTaskCompletion(int index) {
//     setState(() {
//       // Get the task from the appropriate list (either _tasks or _completedTasks)
//       var task;
//       if (index < _tasks.length) {
//         task = _tasks[index]; // Task in _tasks
//       } else {
//         task =
//             _completedTasks[index - _tasks.length]; // Task in _completedTasks
//       }
//
//       final taskId = task['id']; // Get the task ID to identify it uniquely
//
//       if (task['completed']) {
//         // Task is being marked as incomplete, move it back to _tasks
//         task['completed'] = false;
//         _tasks.add(task); // Add back to _tasks
//         _completedTasks.removeWhere(
//             (t) => t['id'] == taskId); // Remove from _completedTasks
//       } else {
//         // Task is being marked as complete, move it to _completedTasks
//         task['completed'] = true;
//         task['completedDate'] = DateTime.now();
//         _completedTasks.add(task); // Add to _completedTasks
//         _tasks.removeAt(index); // Remove from _tasks
//       }
//       _calculateProgress(); // Update the progress bar
//     });
//   }
//
//   void _sortTasks() {
//     List<Map<String, dynamic>> sorted = [..._tasks];
//     if (_sortOrder == 'Due Date') {
//       sorted.sort((a, b) => a['dueDate'].compareTo(b['dueDate']));
//     } else {
//       sorted.sort((a, b) => b['id'].compareTo(a['id']));
//     }
//     _tasks.clear();
//     _tasks.addAll(sorted);
//   }
//
//   Color _getPriorityColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return Colors.red;
//       case 'Medium':
//         return Colors.orange;
//       case 'Low':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   void _editTask(int index) {
//     setState(() {
//       _taskController.text = _tasks[index]['task'];
//       _selectedDueDate = _tasks[index]['dueDate'];
//       _selectedPriority = _tasks[index]['priority'];
//       _editingIndex = index;
//       final task = _tasks[index];
//       _taskNotesController.text = task['notes'] ?? '';
//     });
//     _openTaskDialog(index: index);
//   }
//
//   void _deleteCompletedTask(int index) {
//     setState(() {
//       _completedTasks.removeAt(index);
//     });
//   }
//
//   // Pages for other tabs (empty for now)
//   Widget _buildTabContent(int index) {
//     switch (index) {
//       case 1:
//         return _buildCalendarPage();
//       case 2:
//         return _buildCompletedTasksList(); // Show completed tasks
//       case 3:
//         return LeaderboardPage();
//       case 4:
//         return SettingsPage();
//       default:
//         return _buildTaskList();
//     }
//   }
//
//   Widget _buildCompletedTasksList() {
//     _completedTasks.sort((a, b) => b['completedDate'].compareTo(a['completedDate']));
//     return _completedTasks.isEmpty
//         ? Center(child: Text('No completed tasks yet.'))
//         : ListView.builder(
//             itemCount: _completedTasks.length,
//             itemBuilder: (context, index) {
//               final task = _completedTasks[index];
//               return Card(
//                 child: ListTile(
//                   title: Row(
//                     children: [
//                       Container(
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           color: _getPriorityColor(task['priority']),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       Text(task['task']),
//                     ],
//                   ),
//                   subtitle: Text(
//                     'Completed on: ${DateFormat('MMM dd, yyyy').format(task['completedDate'])}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   leading: Icon(Icons.check_circle, color: Colors.green),
//                   trailing: IconButton(
//                     icon: Icon(Icons.undo, color: Colors.blue), // Undo icon
//                     onPressed: () =>
//                         _unmarkTask(index), // Function to unmark task
//                   ),
//                 ),
//               );
//             },
//           );
//   }
//
//   void _unmarkTask(int index) {
//     setState(() {
//       final task = _completedTasks.removeAt(index);
//       task['completed'] = false;
//       _tasks.add(task); // Move it back to the main task list
//       _sortTasks(); // Re-sort tasks to maintain correct priority and due date order
//       _groupTasksByPriority(); // Re-group tasks based on priority
//       _calculateProgress(); // Recalculate progress after unmarking the task
//     });
//   }
//
//   Widget _buildProgressBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Column(
//         children: [
//           Container(
//             width:
//                 MediaQuery.of(context).size.width * 0.8, // 80% of screen width
//             height: 20, // Progress bar height
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10), // Rounded corners
//               color: Colors.grey[300], // Background color
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: LinearProgressIndicator(
//                 value: _progress,
//                 backgroundColor: Colors.transparent,
//                 valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Progress: ${((_progress) * 100).toStringAsFixed(0)}%',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTaskList() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 4),
//               DropdownButton<String>(
//                 value: _sortOrder,
//                 isExpanded: true,
//                 onChanged: (value) {
//                   setState(() {
//                     _sortOrder = value!;
//                     _sortTasks();
//                     _groupTasksByPriority();
//                   });
//                 },
//                 items: ['Due Date', 'Recently Added']
//                     .map((option) => DropdownMenuItem<String>(
//                           value: option,
//                           child: Text(option),
//                         ))
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//         // Progress Bar Section
//         _buildProgressBar(), // Call the new method to build the progress bar
//
//         // Task List Section
//         _tasks.isEmpty
//             ? Center(child: Text('No tasks added.'))
//             : Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (_highPriorityTasks
//                           .where((task) => !task['completed'])
//                           .isNotEmpty)
//                         _buildPrioritySection(
//                             'PRIORITY: HIGH', Colors.red, _highPriorityTasks),
//                       if (_mediumPriorityTasks
//                           .where((task) => !task['completed'])
//                           .isNotEmpty)
//                         _buildPrioritySection('PRIORITY: MEDIUM', Colors.orange,
//                             _mediumPriorityTasks),
//                       if (_lowPriorityTasks
//                           .where((task) => !task['completed'])
//                           .isNotEmpty)
//                         _buildPrioritySection(
//                             'PRIORITY: LOW', Colors.green, _lowPriorityTasks),
//                     ],
//                   ),
//                 ),
//               )
//       ],
//     );
//   }
//
//   Widget _buildCalendarPage() {
//     return CalendarPage(
//       tasks: _tasks,
//       selectedDay: _selectedDay,
//       focusedDay: _focusedDay,
//       onDaySelected: (selected, focused) {
//         setState(() {
//           _selectedDay = selected;
//           _focusedDay = focused;
//         });
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TaskQuest'),
//         backgroundColor: primaryGreen,
//         centerTitle: true,
//       ),
//       body: _buildTabContent(_currentIndex),
//       floatingActionButton: _currentIndex == 0
//           ? FloatingActionButton(
//         backgroundColor: primaryGreen,
//         child: Icon(Icons.add, color: Colors.white),
//         onPressed: () => _openTaskDialog(),
//       )
//           : null,
//
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (int index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: _buildNavBarItemIcon(0, Icons.home),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: _buildNavBarItemIcon(1, Icons.calendar_today),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: _buildNavBarItemIcon(2, Icons.check_circle),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: _buildNavBarItemIcon(3, Icons.leaderboard),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: _buildNavBarItemIcon(4, Icons.settings),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavBarItemIcon(int index, IconData iconData) {
//     bool isSelected = _currentIndex == index;
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: isSelected ? primaryGreen : Colors.transparent,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Icon(
//         iconData,
//         color: isSelected ? Colors.white : primaryGreen,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'components/const/colors.dart';
import 'components/button_widget.dart';
import 'calendar_page.dart';
import 'leaderboard_page.dart';
import 'settings_page.dart';

class TaskManagerPage extends StatefulWidget {
  @override
  _TaskManagerPageState createState() => _TaskManagerPageState();
}

List<Map<String, dynamic>> _highPriorityTasks = [];
List<Map<String, dynamic>> _mediumPriorityTasks = [];
List<Map<String, dynamic>> _lowPriorityTasks = [];

class _TaskManagerPageState extends State<TaskManagerPage> {
  final List<Map<String, dynamic>> _completedTasks = [];
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _taskNotesController = TextEditingController();

  String _sortOrder = 'Due Date';
  DateTime? _selectedDueDate;
  String _selectedPriority = 'Medium';
  int? _editingIndex;
  double _progress = 0.0;
  int _currentIndex = 0;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _userPoints = 0; // 🟡 Track user points

  void _calculateProgress() {
    int completedCount = _completedTasks.length;
    int totalCount = _tasks.length + _completedTasks.length;
    _progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    setState(() {});
  }

  void _awardPoints(String priority) {
    int earnedPoints = 0;
    if (priority == 'High') earnedPoints = 10;
    else if (priority == 'Medium') earnedPoints = 5;
    else if (priority == 'Low') earnedPoints = 2;
    _userPoints += earnedPoints;
    setState(() {});
  }

  void _openTaskDialog({int? index}) {
    if (index != null) {
      _taskController.text = _tasks[index]['task'];
      _selectedDueDate = _tasks[index]['dueDate'];
      _selectedPriority = _tasks[index]['priority'];
      _editingIndex = index;
      final task = _tasks[index];
      _taskNotesController.text = task['notes'] ?? '';
    } else {
      _taskController.clear();
      _taskNotesController.clear();
      _selectedDueDate = null;
      _selectedPriority = 'Medium';
      _editingIndex = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                          : 'Due Date: ${DateFormat('MMM dd, yyyy').format(_selectedDueDate!)}',
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
                    items: ['High', 'Medium', 'Low'].map((priority) {
                      return DropdownMenuItem(value: priority, child: Text(priority));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedPriority = value!);
                    },
                  ),
                  SizedBox(height: 12),
                  ButtonWidget(
                    text: _editingIndex == null ? 'Add Task' : 'Update Task',
                    onPressed: _addOrEditTask,
                  ),
                  TextField(
                    controller: _taskNotesController,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Add any details...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addOrEditTask() {
    final text = _taskController.text.trim();
    if (text.isNotEmpty && _selectedDueDate != null) {
      setState(() {
        final taskId = DateTime.now().millisecondsSinceEpoch;
        final taskData = {
          'id': taskId,
          'task': text,
          'dueDate': _selectedDueDate!,
          'priority': _selectedPriority,
          'completed': false,
          'notes': _taskNotesController.text.trim(),
        };

        if (_editingIndex != null) {
          _tasks[_editingIndex!] = taskData;
        } else {
          _tasks.add(taskData);
        }

        _sortTasks();
        _groupTasksByPriority();
        _calculateProgress();
      });

      _taskController.clear();
      _taskNotesController.clear();
      _selectedDueDate = null;
      _selectedPriority = 'Medium';
      _editingIndex = null;
      Navigator.pop(context);
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      var task = (index < _tasks.length)
          ? _tasks[index]
          : _completedTasks[index - _tasks.length];

      final taskId = task['id'];

      if (task['completed']) {
        task['completed'] = false;
        _tasks.add(task);
        _completedTasks.removeWhere((t) => t['id'] == taskId);
      } else {
        task['completed'] = true;
        task['completedDate'] = DateTime.now();
        _completedTasks.add(task);
        _tasks.removeAt(index);

        // 🟢 Award points here!
        _awardPoints(task['priority']);
      }

      _calculateProgress();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _groupTasksByPriority();
      _calculateProgress();
    });
  }

  void _editTask(int index) {
    setState(() {
      _taskController.text = _tasks[index]['task'];
      _selectedDueDate = _tasks[index]['dueDate'];
      _selectedPriority = _tasks[index]['priority'];
      _editingIndex = index;
      final task = _tasks[index];
      _taskNotesController.text = task['notes'] ?? '';
    });
    _openTaskDialog(index: index);
  }

  void _deleteCompletedTask(int index) {
    setState(() {
      _completedTasks.removeAt(index);
    });
  }

  void _unmarkTask(int index) {
    setState(() {
      final task = _completedTasks.removeAt(index);
      task['completed'] = false;
      _tasks.add(task);
      _sortTasks();
      _groupTasksByPriority();
      _calculateProgress();
    });
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      return _sortOrder == 'Due Date'
          ? a['dueDate'].compareTo(b['dueDate'])
          : b['id'].compareTo(a['id']);
    });
  }

  void _groupTasksByPriority() {
    _highPriorityTasks = _tasks.where((t) => t['priority'] == 'High').toList();
    _mediumPriorityTasks = _tasks.where((t) => t['priority'] == 'Medium').toList();
    _lowPriorityTasks = _tasks.where((t) => t['priority'] == 'Low').toList();
  }

  Future<void> _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final int index = _tasks.indexOf(task);
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _getPriorityColor(task['priority']),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text(task['task']),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due: ${DateFormat('MMM dd, yyyy').format(task['dueDate'])}'),
            if (task['notes']?.isNotEmpty ?? false)
              Text('Notes: ${task['notes']}'),
          ],
        ),
        leading: Checkbox(
          value: task['completed'],
          onChanged: (_) => _toggleTaskCompletion(index),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.green),
              onPressed: () => _editTask(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(index),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildProgressBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 6),
              Text(
                'Points: $_userPoints',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Progress: ${(_progress * 100).toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButton<String>(
            value: _sortOrder,
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                _sortOrder = value!;
                _sortTasks();
                _groupTasksByPriority();
              });
            },
            items: ['Due Date', 'Recently Added']
                .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
          ),
        ),
        _buildProgressBar(),
        _tasks.isEmpty
            ? Expanded(child: Center(child: Text('No tasks added.')))
            : Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_highPriorityTasks.any((t) => !t['completed']))
                  _buildPrioritySection('PRIORITY: HIGH', Colors.red, _highPriorityTasks),
                if (_mediumPriorityTasks.any((t) => !t['completed']))
                  _buildPrioritySection('PRIORITY: MEDIUM', Colors.orange, _mediumPriorityTasks),
                if (_lowPriorityTasks.any((t) => !t['completed']))
                  _buildPrioritySection('PRIORITY: LOW', Colors.green, _lowPriorityTasks),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySection(String title, Color color, List<Map<String, dynamic>> tasks) {
    final filtered = tasks.where((task) => !task['completed']).toList();
    if (filtered.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ...filtered.map((task) => _buildTaskCard(task)).toList(),
        ],
      ),
    );
  }

  Widget _buildCompletedTasksList() {
    _completedTasks.sort((a, b) => b['completedDate'].compareTo(a['completedDate']));
    return _completedTasks.isEmpty
        ? Center(child: Text('No completed tasks yet.'))
        : ListView.builder(
      itemCount: _completedTasks.length,
      itemBuilder: (context, index) {
        final task = _completedTasks[index];
        return Card(
          child: ListTile(
            title: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task['priority']),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(task['task']),
              ],
            ),
            subtitle: Text(
              'Completed on: ${DateFormat('MMM dd, yyyy').format(task['completedDate'])}',
              style: const TextStyle(fontSize: 14),
            ),
            leading: Icon(Icons.check_circle, color: Colors.green),
            trailing: IconButton(
              icon: Icon(Icons.undo, color: Colors.blue),
              onPressed: () => _unmarkTask(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarPage() {
    return CalendarPage(
      tasks: _tasks,
      selectedDay: _selectedDay,
      focusedDay: _focusedDay,
      onDaySelected: (selected, focused) {
        setState(() {
          _selectedDay = selected;
          _focusedDay = focused;
        });
      },
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 1:
        return _buildCalendarPage();
      case 2:
        return _buildCompletedTasksList();
      case 3:
        return LeaderboardPage();
      case 4:
        return SettingsPage();
      default:
        return _buildTaskList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskQuest'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: _buildTabContent(_currentIndex),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: primaryGreen,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _openTaskDialog(),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: _buildNavBarItemIcon(0, Icons.home), label: ''),
          BottomNavigationBarItem(icon: _buildNavBarItemIcon(1, Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: _buildNavBarItemIcon(2, Icons.check_circle), label: ''),
          BottomNavigationBarItem(icon: _buildNavBarItemIcon(3, Icons.leaderboard), label: ''),
          BottomNavigationBarItem(icon: _buildNavBarItemIcon(4, Icons.settings), label: ''),
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
      child: Icon(iconData, color: isSelected ? Colors.white : primaryGreen),
    );
  }
}
