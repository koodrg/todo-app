import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/scopedmodel/todo_list_model.dart';
import 'package:todo/component/gradient_background.dart';
import 'package:todo/page/add_task_screen.dart';
import 'package:todo/model/hero_ani_model.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/utils/color_utils.dart';
import 'package:todo/utils/datetime_utils.dart';
import 'package:todo/component/task_card.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  HeroId _generateHeroIds(Task task) {
    return HeroId(
      codePointId: 'code_point_id_${task.id}',
      progressId: 'progress_id_${task.id}',
      titleId: 'title_id_${task.id}',
      remainingTaskId: 'remaining_task_id_${task.id}',
    );
  }

  String currentDay(BuildContext context) {
    return DateTimeUtils.currentDay;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
        builder: (BuildContext context, Widget child, TodoListModel model) {
      var _isLoading = model.isLoading;
      var _tasks = model.tasks;
      var _todos = model.todos;
      var backgroundColor = _tasks.isEmpty || _tasks.length == _currentPageIndex
          ? Colors.blueGrey
          : ColorUtils.getColorFrom(id: _tasks[_currentPageIndex].color);
      if (!_isLoading) {
        // move the animation value towards upperbound only when loading is complete
        _controller.forward();
      }
      return GradientBackground(
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : FadeTransition(
                  opacity: _animation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 0.0, left: 56.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // ShadowImage(),
                            Container(
                              // margin: EdgeInsets.only(top: 22.0),
                              child: Text(
                                //'${widget.currentDay(context)}',
                                'Hello',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 28.0),
                              ),
                            ),
                            Text(
                              'Today: ${widget.currentDay(context)} ${DateTimeUtils.currentDate} ${DateTimeUtils.currentMonth}',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16.0),
                            ),
                            Container(height: 16.0),
                            Text(
                              'You have ${_todos.where((todo) => todo.isCompleted == 0).length} tasks to complete',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16.0),
                            ),
                            Container(
                              height: 16.0,
                            )
                            // Container(
                            //   margin: EdgeInsets.only(top: 42.0),
                            //   child: Text(
                            //     'TODAY : FEBURARY 13, 2019',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .subtitle
                            //         .copyWith(color: Colors.white.withOpacity(0.8)),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Expanded(
                        key: _backdropKey,
                        flex: 1,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification) {
                              print(
                                  "ScrollNotification = ${_pageController.page}");
                              var currentPage =
                                  _pageController.page.round().toInt();
                              if (_currentPageIndex != currentPage) {
                                setState(() => _currentPageIndex = currentPage);
                              }
                            }
                          },
                          child: PageView.builder(
                            controller: _pageController,
                            itemBuilder: (BuildContext context, int index) {
                              return TaskCard(
                                backdropKey: _backdropKey,
                                color: ColorUtils.getColorFrom(
                                    id: _tasks[index].color),
                                getHeroIds: widget._generateHeroIds,
                                getTaskCompletionPercent:
                                    model.getTaskCompletionPercent,
                                getTotalTodos: model.getTotalTodosFrom,
                                task: _tasks[index],
                              );
                            },
                            itemCount: _tasks.length,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 100.0),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
