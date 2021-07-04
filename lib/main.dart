import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoapp/Todos.dart';
import 'package:todoapp/Todosdao.dart';
import 'package:todoapp/completedPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var tfTodo = TextEditingController();
  var formKey = GlobalKey<FormState>();

  Future<void> delete(todo_id) async {
    await Todosdao().deleteTodo(todo_id);
  }

  Future<void> add(todo_text) async {
    await Todosdao().addTodo(todo_text);
  }

  Future<List<Todos>> allUncompletedTodos() async {
    var list = await Todosdao().allUncompletedTodos();
    return list;
  }

  //------Completed Parts--------------
  Future<void> controlTodo(todo_id, todo_control) async {
    await Todosdao().controlTodo(todo_id, todo_control);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text("To Do App"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CompletedPage()));
            },
            icon: Icon(Icons.format_indent_increase_sharp),
          ),
        ],
      ),
      body: FutureBuilder<List<Todos>>(
        future: allUncompletedTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data;
            return ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                var todo = list[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Card(
                    margin: EdgeInsets.all(4.0),
                    elevation: 3,
                    shadowColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        todo.todo_text,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black87,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          print("Clicked OK");
                          setState(() {
                            controlTodo(todo.todo_id, 1);
                          });
                        },
                        icon: Icon(Icons.assignment_turned_in_outlined,
                            color: Colors.grey),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          print("Clicked Delete");
                          setState(() {
                            delete(todo.todo_id);
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("No Data"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                title: Text(
                  "Add ToDo List",
                  textAlign: TextAlign.center,
                ),
                content: Form(
                  key: formKey,
                  child: SizedBox(
                    height: 120,
                    child: Column(
                      children: [
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: tfTodo,
                          decoration: InputDecoration(
                            hintText: "Some text here...",
                          ),
                          validator: (tfgirdisi) {
                            if (tfgirdisi!.isEmpty) {
                              return "Add some words";
                            }
                            return null;
                          },
                        ),
                        Spacer(),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tfTodo.clear();
                                  Navigator.pop(context);
                                });
                              },
                              child: Text("Cancel"),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                bool controllerResult =
                                    formKey.currentState!.validate();

                                if (controllerResult) {
                                  setState(() {
                                    add(tfTodo.text);
                                    tfTodo.clear();
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: Text("Add"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
