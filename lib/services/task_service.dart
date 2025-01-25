import 'dart:convert';

import 'package:bricklayer_app/domain/Tarefas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskManagerService {
  static const String _taskListKey = 'taskListKey';

  // Adicionar uma nova tarefa
  Future<void> addTask(Tarefa tarefa) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList(_taskListKey) ?? [];

    taskList.add(json.encode(tarefa.toMap()));
    await prefs.setStringList(_taskListKey, taskList);
  }

  // Atualizar uma tarefa existente
  Future<void> updateTask(int index, Tarefa updatedTarefa) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList(_taskListKey) ?? [];

    if (index >= 0 && index < taskList.length) {
      taskList[index] = json.encode(updatedTarefa.toMap());
      await prefs.setStringList(_taskListKey, taskList);
    }
  }

  // Deletar uma tarefa existente
  Future<void> deleteTask(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList(_taskListKey) ?? [];

    if (index >= 0 && index < taskList.length) {
      taskList.removeAt(index);
      await prefs.setStringList(_taskListKey, taskList);
    }
  }

  // Recuperar todas as tarefas armazenadas
  Future<List<Tarefa>> getTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList(_taskListKey) ?? [];

    return taskList.map((taskString) {
      return Tarefa.fromMap(json.decode(taskString));
    }).toList();
  }
}
