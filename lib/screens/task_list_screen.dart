import 'package:flutter/material.dart';
import 'package:internship_task_manager/models/task_model.dart';
import 'package:internship_task_manager/screens/add_task_screen.dart';
import 'package:internship_task_manager/services/storage_service.dart';
import 'package:internship_task_manager/utils/page_transitions.dart';
import 'package:internship_task_manager/widgets/animated_fab.dart';
import 'package:uuid/uuid.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });
    
    final tasks = await StorageService.loadTasks();
    
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTasks() async {
    await StorageService.saveTasks(_tasks);
  }

  Future<void> _addTask(String title) async {
    final newTask = TaskModel(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    
    setState(() {
      _tasks.add(newTask);
    });
    
    await _saveTasks();
  }

  Future<void> _deleteTask(String id) async {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
    
    await _saveTasks();
  }

  Future<void> _toggleTaskComplete(String id) async {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          isCompleted: !_tasks[index].isCompleted,
        );
      }
    });
    
    await _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks yet!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add a task',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: task.isCompleted
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.blue.withOpacity(0.1),
                            ),
                            child: Checkbox(
                              value: task.isCompleted,
                              onChanged: (value) {
                                _toggleTaskComplete(task.id);
                              },
                              shape: const CircleBorder(),
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isCompleted
                                  ? Colors.grey[600]
                                  : null,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(task.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            onPressed: () {
                              _deleteTask(task.id);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: AnimatedFAB(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            ScalePageRoute(
              child: const AddTaskScreen(),
            ),
          );
          
          if (result != null && result is String) {
            await _addTask(result);
          }
        },
        icon: Icons.add_rounded,
        tooltip: 'Add Task',
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

