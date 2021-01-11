import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/scopedmodel/todo_list_model.dart';
import 'package:todo/model/todo_model.dart';


class EditTodoScreen extends StatefulWidget {
  final String name;
  final String parent;
  final String id;

  EditTodoScreen({
    @required this.name,
    @required this.parent,
    @required this.id,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditTodoScreenState();
  }
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final  btnSaveTitle = "Save Changes";
  String newTodo;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      newTodo = widget.name;
      //taskColor = widget.color;
      //taskIcon = widget.icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Edit Task',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black26),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task will help you group related task!',
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
                Container(
                  height: 16.0,
                ),
                TextFormField(
                  initialValue: newTodo,
                  onChanged: (text) {
                    setState(() => newTodo = text);
                  },
                  //cursorColor: taskColor,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Category Name...',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      )),
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 36.0),
                ),
                Container(
                  height: 26.0,
                ),
                Row(
                  children: [
                    // ColorPickerBuilder(
                    //     color: taskColor,
                    //     onColorChanged: (newColor) =>
                    //         setState(() => taskColor = newColor)),
                    Container(
                      width: 22.0,
                    ),
                    // IconPickerBuilder(
                    //     iconData: taskIcon,
                    //     highlightColor: taskColor,
                    //     action: (newIcon) =>
                    //         setState(() => taskIcon = newIcon)),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(
            builder: (BuildContext context) {
              return FloatingActionButton.extended(
                heroTag: 'fab_new_card',
                icon: Icon(Icons.save),
                //backgroundColor: taskColor,
                label: Text(btnSaveTitle),
                onPressed: () {
                  if (newTodo.isEmpty) {
                    final snackBar = SnackBar(
                      content: Text(
                          'Ummm... It seems that you are trying to add an invisible task which is not allowed in this realm.'),
                      //backgroundColor: taskColor,
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                    // _scaffoldKey.currentState.showSnackBar(snackBar);
                  } else {
                    model.updateTodo( Todo(
                      newTodo,
                      id: widget.id,
                      parent: widget.parent,
                      //id: widget.taskId
                    ));
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

// Reason for wraping fab with builder (to get scafold context)
// https://stackoverflow.com/a/52123080/4934757
