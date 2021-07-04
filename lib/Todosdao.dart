import 'package:todoapp/DbHelper.dart';
import 'package:todoapp/Todos.dart';

class Todosdao {
  Future<List<Todos>> allUncompletedTodos() async {
    var db = await DbHelper.dbConnection();

    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM todos WHERE todo_control like 0");

    return List.generate(maps.length, (i) {
      var satir = maps[i];

      return Todos(
          todo_id: satir["todo_id"],
          todo_text: satir["todo_text"],
          todo_control: satir["todo_control"]);
    });
  }

  Future<List<Todos>> allCompletedTodos() async {
    var db = await DbHelper.dbConnection();

    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM todos WHERE todo_control like 1");

    return List.generate(maps.length, (i) {
      var satir = maps[i];

      return Todos(
          todo_id: satir["todo_id"],
          todo_text: satir["todo_text"],
          todo_control: satir["todo_control"]);
    });
  }

  Future<void> addTodo(String todo_text) async {
    var db = await DbHelper.dbConnection();

    var datas = Map<String, dynamic>();
    datas["todo_text"] = todo_text;

    await db.insert("todos", datas);
  }

  Future<void> deleteTodo(int todo_id) async {
    var db = await DbHelper.dbConnection();
    await db.delete("todos", where: "todo_id = ?", whereArgs: [todo_id]);
  }

  Future<void> controlTodo(int todo_id, int todo_control) async {
    var db = await DbHelper.dbConnection();

    var datas = Map<String, dynamic>();
    datas["todo_control"] = todo_control;

    await db.update("todos", datas, where: "todo_id=?", whereArgs: [todo_id]);
  }
}
