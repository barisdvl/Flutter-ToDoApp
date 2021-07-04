import 'package:flutter/material.dart';
import 'package:todoapp/Todos.dart';
import 'package:todoapp/Todosdao.dart';
import 'package:todoapp/main.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({Key? key}) : super(key: key);

  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  Future<List<Todos>> allCompletedTodos() async {
    var list = await Todosdao().allCompletedTodos();
    return list;
  }

  Future<void> controlTodo(todo_id, todo_control) async {
    await Todosdao().controlTodo(todo_id, todo_control);
  }

  Future<void> delete(todo_id) async {
    await Todosdao().deleteTodo(todo_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Completed Todos"),
      ),
      body: FutureBuilder<List<Todos>>(
        future: allCompletedTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data;
            return ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                var completedlist = list[index];
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
                        completedlist.todo_text,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black87,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          print("Clicked OK");
                          setState(() {
                            controlTodo(completedlist.todo_id, 0);
                          });
                        },
                        icon: Icon(Icons.assignment_turned_in,
                            color: Colors.green),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          print("Clicked Delete");
                          setState(() {
                            delete(completedlist.todo_id);
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
    );
  }
}
