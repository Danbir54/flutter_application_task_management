import 'package:flutter/material.dart';

void main() {
  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  void _addTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    String title = '';
    String description = '';
    int deadline = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
               TextField(
                decoration: const InputDecoration(labelText: "Day's Required"),
                keyboardType: TextInputType.number,
                onChanged: (value) => deadline = int.parse(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Task newTask = Task(title: title, description: description, deadline: deadline);
                _addTask(newTask);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Task Details', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Title: ${task.title}'),
              const SizedBox(height: 8.0),
              Text('Description: ${task.description}'),
              const SizedBox(height: 8.0),
              Text("Day's Required: ${task.deadline}"),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _deleteTask(task);
                  Navigator.pop(sheetContext);
                },
                child: const Text('Delete Task'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Management'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          Task task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            onTap: () => _showTaskDetails(task),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Task {
  final String title;
  final String description;
  final int deadline;

  Task({required this.title, required this.description, required this.deadline});
}
