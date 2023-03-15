import 'package:flutter/material.dart';
import 'package:semi_final_exam/db/todo_database.dart';
import 'package:semi_final_exam/model/todo.dart';
import 'package:semi_final_exam/widget/todo_form_widget.dart';

class AddEditTodoPage extends StatefulWidget {

  final Todo? todo;

  const AddEditTodoPage({
    Key? key,
    this.todo,
  }) : super(key: key);

  @override
  _AddEditTodoPageState createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.todo?.isImportant ?? false;
    title = widget.todo?.title ?? '';
    description = widget.todo?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: TodoFormWidget(
        isImportant: isImportant,
        title: title,
        description: description,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateTodo,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateTodo() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.todo != null;

      if (isUpdating) {
        await updateTodo();
      } else {
        await addTodo();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateTodo() async {
    final note = widget.todo!.copy(
      isImportant: isImportant,
      title: title,
      description: description,
    );

    await TodoDatabase.instance.update(note);
  }

  Future addTodo() async {
    final note = Todo(
      title: title,
      isImportant: true,
      description: description,
      createdTime: DateTime.now(),
    );

    await TodoDatabase.instance.create(note);
  }
}