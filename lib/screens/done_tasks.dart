import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DontTasks extends StatefulWidget {
  const DontTasks({super.key});

  @override
  State<DontTasks> createState() => _DontTasksState();
}

class _DontTasksState extends State<DontTasks> {
  var doneTask = Hive.box("done_task");
  var task = Hive.box("my_task");
  late final isDark = Theme.of(context).brightness == Brightness.dark;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? Color(0xff061526)
            : Color(0xff052659),
        foregroundColor: Colors.white,
        title: Text('Done Tasks'),
        centerTitle: true,
      ),
      backgroundColor: isDark
          ? Color(0xff0B1D33)
          : Color(0xfffbf8f1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: doneTask.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(color: isDark
                    ? Color(0xff16324F)
                    : Color(0xffefdac9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Expanded(
                  child: ListTile(
                    title: Text(
                      doneTask.getAt(index)['title'],
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Color(0xff1f2b45),
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text(
                      doneTask.getAt(index)['description'],
                      style: TextStyle(color: isDark
                          ? Color(0xffB8C4D6)
                          : Color(0xff736d54),),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        doneTask.deleteAt(index);
                        setState(() {});
                      },
                    ),
                    leading: Checkbox(
                      value: doneTask.getAt(index)['isCompleted'],
                      onChanged: (value) {
                        setState(() {
                          doneTask.getAt(index)['isCompleted'] = value!;
                          task.add(doneTask.getAt(index));
                          doneTask.deleteAt(index);
                        });
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
