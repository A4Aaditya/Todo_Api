import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController taskController = TextEditingController();
  TextEditingController editTaskController = TextEditingController();
  List<String> todos = [
    'Make Project',
    'Make Video',
    'Publish on Youtube',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Visibility(
        visible: todos.isNotEmpty,
        replacement: Center(
          child: Text('No Task to show'),
        ),
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final task = todos[index];
            return ListTile(
              title: Text(task),
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return ['Edit', 'Delete'].map((item) {
                    return PopupMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList();
                },
                onSelected: (selected) {
                  if (selected == 'Edit') {
                    // call edit method
                    editTodo(index);
                  } else if (selected == 'Delete') {
                    // call delete method
                    deleteTodo(index);
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goTodAddScreen,
        child: Icon(Icons.add),
      ),
    );
  }

  void editTodo(int index) {
    String task = todos[index];
    editTaskController.text = task;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: editTaskController,
            decoration: InputDecoration(
              hintText: 'Update Task!',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: close,
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                String updatedTask = editTaskController.text;
                // update the task
                todos[index] = updatedTask;
                setState(() {});
                showConfirmation('Task updated');
                close();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void deleteTodo(int index) {
    // remove item using index
    todos.removeAt(index);
    // update ui after item removal
    showConfirmation('Task Deleted');

    setState(() {});
  }

  void goTodAddScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(
              hintText: 'Enter Task!',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: close,
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: addTask,
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void close() {
    Navigator.pop(context);
  }

  void addTask() {
    String task = taskController.text;
    todos.add(task);

    // update ui
    setState(() {});

    // clear the text field
    taskController.text = '';

    showConfirmation('Task Added');

    // close form after save
    close();
  }

  void showConfirmation(String text) {
    SnackBar snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
