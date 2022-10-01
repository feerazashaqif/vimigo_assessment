import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vimigo_assessment/providers/goal_provider.dart';
import 'package:vimigo_assessment/widgets/bottom_sheet.dart';
import 'package:vimigo_assessment/widgets/goal_path.dart';
import 'models/goal.dart';
import 'widgets/goal_widget.dart';

void main() {
  runApp(ChangeNotifierProvider(
      //Using change notifier for better app performance
      create: (_) => GoalNotifier(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Achievements & Goals'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController pathController;
  late AnimationController goalController;
  late Animation<double> moveLeft, moveRight;
  String dropdownvalue = '1';
  List<String> levels = [];
  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();
    //get static values of Goal list
    goals = Goal.goals;
    for (int x = 0; x < goals.length; x++) {
      levels.add(goals[x].level.toString());
    }
    initAnimationController();
  }

//Set up animation controller for goal path
  initAnimationController() {
    pathController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
        lowerBound: 0,
        upperBound: 4);
    pathController.value = 0.0;

    goalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );

    //Animation to move right-sided box from right side of outer screen
    moveLeft = Tween<double>(begin: 200, end: 0.0).animate(
        CurvedAnimation(parent: goalController, curve: Curves.fastOutSlowIn));

    //Animation to move left-sided box from left side of outer screen
    moveRight = Tween<double>(begin: -200, end: 0.0).animate(
        CurvedAnimation(parent: goalController, curve: Curves.fastOutSlowIn));

    goalController.addListener(() {
      Provider.of<GoalNotifier>(context, listen: false)
          .setScaleValue(goalController.value);
      Provider.of<GoalNotifier>(context, listen: false)
          .setMoveLeftValue(moveLeft.value);
      Provider.of<GoalNotifier>(context, listen: false)
          .setMoveRightValue(moveRight.value);
    });

    //start init animation for GoalWidget
    goalController.forward();

    pathController.addListener(() {
      Provider.of<GoalNotifier>(context, listen: false)
          .setPathAnimationValue(pathController.value);
    });
  }

  @override
  void dispose() {
    pathController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Consumer<GoalNotifier>(builder: (context, goal, child) {
          return Center(
            child: Stack(
              children: [
                SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      Stack(children: [
                        Column(
                          verticalDirection: VerticalDirection.up,
                          children: [
                            Center(
                                child: AnimatedBuilder(
                                    animation: pathController,
                                    builder: (context, c) {
                                      return CustomPaint(
                                        willChange: true,
                                        isComplex: true,
                                        painter: GoalPath(goal.pathAnimation,
                                            color: Colors.yellow,
                                            level: 5,
                                            opacity: goal.scale),
                                        size: Size(
                                            MediaQuery.of(context).size.width,
                                            MediaQuery.of(context).size.height),
                                      );
                                    }))
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            verticalDirection: VerticalDirection.up,
                            children: [
                              const SizedBox(
                                height: 48,
                              ),
                              for (int x = 0; x < goals.length; x++)
                                //Display goal widget containing level and message
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 36.0, vertical: 24),
                                    child: goalWidget(
                                        goals[x].level,
                                        goals[x].message,
                                        goal.pathAnimation,
                                        goal.moveLeft,
                                        goal.moveRight,
                                        goal.scale, () {
                                      if (goal.selected != x ||
                                          !goal.openBottomSheet) {
                                        Provider.of<GoalNotifier>(context,
                                                listen: false)
                                            .setOpenBottomSheet(true);
                                      } else {
                                        Provider.of<GoalNotifier>(context,
                                                listen: false)
                                            .setOpenBottomSheet(false);
                                      }
                                      Provider.of<GoalNotifier>(context,
                                              listen: false)
                                          .setSelected(x);
                                    }))
                            ],
                          ),
                        ),
                      ]),
                      bottomSheet(
                          goals[goal.selected].message,
                          goal.openBottomSheet ? 100.0 : 0.0,
                          AnimationController(vsync: this), () {
                        Provider.of<GoalNotifier>(context, listen: false)
                            .setOpenBottomSheet(false);
                      }),
                    ],
                  ),
                ),
                levels.isEmpty
                    ? Container()
                    : Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: DropdownButton(
                                value: dropdownvalue,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: levels.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                  //Assign value to controller with minus 1 because of level 1 is the first levelof the index
                                  pathController.animateTo(
                                      double.parse(dropdownvalue) - 1);
                                },
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(16),
                                underline: Container(),
                                dropdownColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        }));
  }
}
