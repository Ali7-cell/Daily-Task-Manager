import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internship_task_manager/models/task_model.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _counterKey = 'counter';

  // Save tasks to SharedPreferences
  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(tasksJson));
  }

  // Load tasks from SharedPreferences
  static Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJsonString = prefs.getString(_tasksKey);
    
    if (tasksJsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> tasksJson = jsonDecode(tasksJsonString);
      return tasksJson.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Save counter value
  static Future<void> saveCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);
  }

  // Load counter value
  static Future<int> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_counterKey) ?? 0;
  }
}

