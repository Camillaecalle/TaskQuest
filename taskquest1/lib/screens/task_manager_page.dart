import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import 'settings_page.dart';
import 'calendar_page.dart';

class TaskManagerPage extends StatefulWidget {
  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;
  const TaskManagerPage({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _TaskManagerPageState createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  final List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, dynamic>> _completedTasks = [];
  List<Map<String, dynamic>> _highPriorityTasks = [];
  List<Map<String, dynamic>> _mediumPriorityTasks = [];
  List<Map<String, dynamic>> _lowPriorityTasks = [];

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _taskNotesController = TextEditingController();

  String _sortOrder = 'Due Date';
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedDueTime;
  String _selectedPriority = 'Medium';
  int? _editingIndex;
  double _progress = 0.0;
  int _currentIndex = 0;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  @override
  void initState() {
    super.initState();
    _groupTasksByPriority();
    _calculateProgress();
  }

  void _calculateProgress() {
    int completedCount = _completedTasks.length;
    int totalCount = _tasks.length + completedCount;
    setState(() =>
    _progress = totalCount == 0 ? 0.0 : completedCount / totalCount);
  }

  Future<void> _pickDueDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDueDate = picked);
  }

  Future<void> _pickDueTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedDueTime ?? now,
    );
    if (picked != null) setState(() => _selectedDueTime = picked);
  }

  void _openTaskDialog({int? index}) {
    if (index != null) {
      _editingIndex = index;
      final task = _tasks[index];
      _taskController.text = task['task'];
      final due = task['dueDate'] as DateTime;
      _selectedDueDate = DateTime(due.year, due.month, due.day);
      _selectedDueTime = TimeOfDay(hour: due.hour, minute: due.minute);
      _selectedPriority = task['priority'];
      _taskNotesController.text = task['notes'] ?? '';
    } else {
      _editingIndex = null;
      _taskController.clear();
      _taskNotesController.clear();
      _selectedDueDate = null;
      _selectedDueTime = null;
      _selectedPriority = 'Medium';
    }

    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
            builder: (context, setState) =>
                AlertDialog(
                  backgroundColor: Theme
                      .of(context)
                      .dialogTheme
                      .backgroundColor,
                  shape: Theme
                      .of(context)
                      .dialogTheme
                      .shape,
                  title: Text(_editingIndex == null ? 'Add Task' : 'Edit Task'),
                  content: SingleChildScrollView(
                    child: Column(
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
                                : 'Due: ${DateFormat('MMM dd, yyyy').format(
                                _selectedDueDate!)}',
                          ),
                          trailing: Icon(Icons.calendar_today, color: Theme
                              .of(context)
                              .colorScheme
                              .secondary),
                          onTap: _pickDueDate,
                        ),
                        ListTile(
                          title: Text(
                            _selectedDueTime == null
                                ? 'Select Due Time'
                                : 'Time: ${_selectedDueTime!.format(context)}',
                          ),
                          trailing: Icon(Icons.access_time, color: Theme.of(context).colorScheme.secondary),
                          onTap: _pickDueTime,
                        ),
                        SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
                          items: ['High', 'Medium', 'Low']
                              .map((p) =>
                              DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedPriority = v!),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _addOrEditTask,
                          child: Text(_editingIndex == null ? 'Add' : 'Update'),
                        ),
                        SizedBox(height: 12),
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
                  ),
                ),
          ),
    );
  }

  void _addOrEditTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty || _selectedDueDate == null || _selectedDueTime == null) return;

    final dueDateTime = DateTime(
      _selectedDueDate!.year,
      _selectedDueDate!.month,
      _selectedDueDate!.day,
      _selectedDueTime!.hour,
      _selectedDueTime!.minute,
    );

    final entry = {
      'id': _editingIndex != null
          ? _tasks[_editingIndex!]['id']
          : DateTime.now().millisecondsSinceEpoch,
      'task': text,
      'dueDate': dueDateTime,
      'priority': _selectedPriority,
      'completed': false,
      'notes': _taskNotesController.text.trim(),
    };

    setState(() {
      if (_editingIndex != null) {
        _tasks[_editingIndex!] = entry;
      } else {
        _tasks.add(entry);
      }
      _sortTasks();
      _groupTasksByPriority();
      _calculateProgress();
    });

    Navigator.pop(context);
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _sortTasks();
      _groupTasksByPriority();
      _calculateProgress();
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      final task = _tasks.removeAt(index);
      task['completed'] = !task['completed'];
      if (task['completed']) {
        task['completedDate'] = DateTime.now();
        _completedTasks.add(task);
      } else {
        _tasks.add(task);
      }
      _sortTasks();
      _groupTasksByPriority();
      _calculateProgress();
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
    if (_sortOrder == 'Due Date') {
      _tasks.sort((a, b) => a['dueDate'].compareTo(b['dueDate']));
    } else {
      _tasks.sort((a, b) => b['id'].compareTo(a['id']));
    }
  }

  void _groupTasksByPriority() {
    _highPriorityTasks = _tasks.where((t) => t['priority'] == 'High').toList();
    _mediumPriorityTasks =
        _tasks.where((t) => t['priority'] == 'Medium').toList();
    _lowPriorityTasks = _tasks.where((t) => t['priority'] == 'Low').toList();
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

  Widget _buildPrioritySection(
      String title,
      Color color,
      List<Map<String, dynamic>> tasks,
      ) {
    final items = tasks.where((t) => !t['completed']).toList();
    if (items.isEmpty) return SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        // <-- stretch children to full width
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            // no width needed; it will fill because of stretch
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // each task card below
          ...items.map((task) => _buildTaskCard(task)).toList(),
        ],
      ),
    );
  }


  Widget _buildTaskCard(Map<String, dynamic> task) {
    final index = _tasks.indexOf(task);
    return Card(
      color: Theme
          .of(context)
          .cardTheme
          .color,
      child: ListTile(
        leading: Checkbox(
          value: task['completed'],
          onChanged: (_) => _toggleTaskCompletion(index),
        ),
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
            Expanded(child: Text(task['task'])),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due: ${DateFormat('MMM dd, yyyy – hh:mm a').format(task['dueDate'])}'),
            if (task['notes'] != null && task['notes'].isNotEmpty)
              Text('Notes: ${task['notes']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Theme
                  .of(context)
                  .primaryColor),
              onPressed: () => _openTaskDialog(index: index),
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

  Widget _buildCompletedTasksList() {
    _completedTasks.sort((a, b) =>
        b['completedDate'].compareTo(a['completedDate']));
    if (_completedTasks.isEmpty) {
      return Center(child: Text('No completed tasks yet.'));
    }
    return ListView.builder(
      itemCount: _completedTasks.length,
      itemBuilder: (context, i) {
        final task = _completedTasks[i];
        return Card(
          color: Theme
              .of(context)
              .cardTheme
              .color,
          child: ListTile(
            leading: Icon(Icons.check_circle, color: Theme
                .of(context)
                .primaryColor),
            title: Text(task['task']),
            subtitle: Text(
              'Completed on: ${DateFormat('MMM dd, yyyy').format(
                  task['completedDate'])}',
            ),
            trailing: IconButton(
              icon: Icon(Icons.undo, color: Theme
                  .of(context)
                  .colorScheme
                  .secondary),
              onPressed: () => _unmarkTask(i),
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

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme
                  .of(context)
                  .colorScheme
                  .surface,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Theme
                    .of(context)
                    .primaryColor),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Progress: ${(_progress * 100).toStringAsFixed(0)}%',
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 1:
        return _buildCalendarPage();
      case 2:
        return _buildCompletedTasksList();
      case 3:
        return Center(child: Text('Progress Overview - Empty for now.'));
      case 4:
        return SettingsPage(
          currentTheme: widget.currentTheme,
          onThemeChanged: widget.onThemeChanged,
        );
      default:
        return Column(
          children: [
            DropdownButton<String>(
              value: _sortOrder,
              isExpanded: true,
              onChanged: (v) {
                setState(() {
                  _sortOrder = v!;
                  _sortTasks();
                  _groupTasksByPriority();
                });
              },
              items: ['Due Date', 'Recently Added']
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
            ),
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrioritySection(
                        'PRIORITY: HIGH', Colors.red, _highPriorityTasks),
                    _buildPrioritySection('PRIORITY: MEDIUM', Colors.orange,
                        _mediumPriorityTasks),
                    _buildPrioritySection(
                        'PRIORITY: LOW', Colors.green, _lowPriorityTasks),
                  ].where((w) => w != null).toList() as List<Widget>,
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _navIcon(int index, IconData iconData) {
    final isSelected = _currentIndex == index;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Theme
            .of(context)
            .primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(
        iconData,
        color: isSelected
            ? Colors.white
            : Theme
            .of(context)
            .colorScheme
            .secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Task Manager'),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        centerTitle: true,
      ),
      body: _buildTabContent(_currentIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () => _openTaskDialog(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: _navIcon(0, Icons.home), label: ''),
          BottomNavigationBarItem(
              icon: _navIcon(1, Icons.calendar_today), label: ''),
          BottomNavigationBarItem(
              icon: _navIcon(2, Icons.check_circle), label: ''),
          BottomNavigationBarItem(
              icon: _navIcon(3, Icons.leaderboard), label: ''),
          BottomNavigationBarItem(icon: _navIcon(4, Icons.settings), label: ''),
        ],
      ),
    );
  }
}