import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];

load() async {
  tasks = await ApiService.listTaskByStatus("New");
  setState(() {});
}


  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(tasks[i].title),
            subtitle: Text(tasks[i].description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await ApiService.deleteTask(tasks[i].id);
                load();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ApiService.createTask("Demo Task", "API Working");
          load();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
