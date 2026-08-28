import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../widgets/TextField_widgets.dart';

class AddTask extends StatefulWidget {
  final int? index;

  const AddTask({super.key, this.index});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var box = Hive.box("my_task");

  final formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String selectedLevel = "Medium";

  @override
  void initState() {
    super.initState();

    if (widget.index != null) {
      var task = box.getAt(widget.index!);

      titleController.text = task["title"];
      descriptionController.text = task["description"];

      // Get old date
      if (task["date"] != null) {
        selectedDate = DateTime.parse(task["date"]);
      }

      // Get old time
      if (task["time"] != null) {
        var timeParts = task["time"].split(":");

        selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }

      // Get old level
      selectedLevel = task["level"] ?? "Medium";
    }
  }

  // Choose Date
  Future<void> chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Choose Time
  Future<void> chooseTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? Color(0xff061526)
            : Color(0xff052659),
        foregroundColor: Colors.white,
        title: widget.index != null ? Text('Edit Task',style: TextStyle( fontSize: 30)) : Text('Add Task',style: TextStyle( fontSize: 30)),
        centerTitle: true,
      ),

      backgroundColor: isDark
          ? Color(0xff0B1D33)
          : Color(0xfffbf8f1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              SizedBox(height: 20),

              // Task Title
              TextfieldWidgets(
                controller: titleController,
                vali: 'Please enter a title',
                hint: 'Task Title',
              ),

              SizedBox(height: 20),

              // Task Description
              TextfieldWidgets(
                controller: descriptionController,
                vali: 'Please enter a description',
                hint: 'Task Description',
              ),

              SizedBox(height: 20),

              // Date
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: chooseDate,
                      icon: Icon(Icons.calendar_month),
                      label: Text(
                        selectedDate == null
                            ? "Choose Date"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  // Time
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: chooseTime,
                      icon: Icon(Icons.access_time),
                      label: Text(
                        selectedTime == null
                            ? "Choose Time"
                            : selectedTime!.format(context),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Level
              DropdownButtonFormField<String>(
                value: selectedLevel,

                decoration: InputDecoration(
                  labelText: "Task Level",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                items: [
                  DropdownMenuItem(value: "Low", child: Text("Low")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "High", child: Text("High")),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
              ),

              SizedBox(height: 30),

              // Add / Edit Button
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    var taskData = {
                      "title": titleController.text,
                      "description": descriptionController.text,

                      // Save Date
                      "date": selectedDate?.toIso8601String(),

                      // Save Time
                      "time": selectedTime == null
                          ? null
                          : "${selectedTime!.hour}:${selectedTime!.minute}",

                      // Save Level
                      "level": selectedLevel,

                      // Completed
                      "isCompleted": widget.index != null
                          ? box.getAt(widget.index!)["isCompleted"]
                          : false,
                    };

                    if (widget.index != null) {
                      box.putAt(widget.index!, taskData);
                    } else {
                      box.add(taskData);
                    }

                    Navigator.pop(context);
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? Color(0xff5483B3)
                      : Color(0xffd06536),

                  foregroundColor: Colors.white,

                  fixedSize: Size(200, 70),
                ),

                child: widget.index != null
                    ? Text('Edit Task')
                    : Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
