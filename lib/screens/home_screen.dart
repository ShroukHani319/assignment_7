import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'profile_screen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:untitled/controller/theme_controller.dart';

import '../controller/theme_controller.dart';
import 'add_task.dart';
import 'done_tasks.dart';

class HomeScreen extends StatefulWidget {
  final ThemeController theme;

  const HomeScreen({super.key, required this.theme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var box = Hive.box("my_task");
  var doneBox = Hive.box("done_task");
  Box profileBox = Hive.box('profile');



  @override
  Widget build(BuildContext context) {
    String name = profileBox.get('name', defaultValue: 'User');
    setState(() {
      name = profileBox.get('name', defaultValue: 'User');
    });
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List tasks = box.values.toList();

    tasks.sort((a, b) {
      Map<String, int> priority = {
        "High": 1,
        "Medium": 2,
        "Low": 3,
      };

      return priority[a["level"]]!.compareTo(
        priority[b["level"]]!,
      );
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? Color(0xff061526)
            : Color(0xff052659),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              widget.theme.changeTheme();
            },
            icon: Icon(
              widget.theme.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
        ],

        title: Text('Welcome $name 👋',style: TextStyle( fontSize: 30),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark
            ? Color(0xff5483B3)
            : Color(0xff052659),

        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          ).then((value) {
            setState(() {});
          });
        },
      ),
      backgroundColor: isDark
          ? Color(0xff0B1D33)
          : Color(0xfffbf8f1),
      body: (box.isEmpty)
          ? Center(
              child: Lottie.asset(
                "assets/completed.json",
                width: 300,
                height: 300,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
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
                          title: box.getAt(index)["isCompleted"]
                              ? Text(
                                  box.getAt(index)["title"],
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              : Text(
                                  box.getAt(index)["title"],
                                  style: TextStyle(color: isDark
                                      ? Colors.white
                                      : Color(0xff1f2b45),

                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                box.getAt(index)["description"],
                                style: TextStyle(color: isDark
                                    ? Color(0xffB8C4D6)
                                    : Color(0xff736d54),
                                ),
                              ),

                              SizedBox(height: 8),

                              if (box.getAt(index)["date"] != null)
                                Text(
                                  "📅 ${DateTime.parse(box.getAt(index)["date"]).day}/"
                                  "${DateTime.parse(box.getAt(index)["date"]).month}/"
                                  "${DateTime.parse(box.getAt(index)["date"]).year}",
                                  style: TextStyle( color: isDark
                                      ? Color(0xffB8C4D6)
                                      : Color(0xff736d54),
                                  ),
                                ),

                              if (box.getAt(index)["time"] != null)
                                Text(
                                  "⏰ ${box.getAt(index)["time"]}",
                                  style: TextStyle(color: isDark
                                      ? Color(0xffB8C4D6)
                                      : Color(0xff736d54),
                                  ),
                                ),

                              Text(
                                "⭐ Level: ${box.getAt(index)["level"]}",
                                style: TextStyle(
                                  color: isDark
                                      ? Color(0xffB8C4D6)
                                      : Color(0xff736d54),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          leading: Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            value: box.getAt(index)["isCompleted"],
                            onChanged: (value) {
                              setState(() {
                                box.getAt(index)["isCompleted"] = value!;
                                doneBox.add(box.getAt(index));
                                box.deleteAt(index);
                              });
                            },
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(value: 1, child: Text("Edit")),
                                PopupMenuItem(value: 2, child: Text("Delete")),
                              ];
                            },
                            onSelected: (value) {
                              if (value == 2) {
                                box.deleteAt(index);
                                setState(() {});
                              }
                              if (value == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTask(index: index),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Home
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DontTasks(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }
          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTask(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),

        ],
      ),
    );
  }
}
