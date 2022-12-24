import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:semi_final_exam/db/todo_database.dart';
import 'package:semi_final_exam/model/note.dart';
import 'package:semi_final_exam/page/add_edit_todo_page.dart';

class TodoDetailPage extends StatefulWidget {
  final int todoId;

  const TodoDetailPage({
    Key? key,
    required this.todoId,
  }) : super(key: key);

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {

  late Todo todo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    todo = await TodoDatabase.instance.readTodo(widget.todoId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            todo.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat.yMMMd().format(todo.createdTime),
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            todo.description,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          )
        ],
      ),
    ),
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined, color: Colors.grey),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditTodoPage(todo: todo),
        ));
        refreshNote();
      });

  Widget deleteButton() => IconButton(
    icon: const Icon(Icons.delete, color: Colors.grey),
    onPressed: () async {
      await TodoDatabase.instance.delete(widget.todoId);
      Navigator.of(context).pop();
    },
  );
}