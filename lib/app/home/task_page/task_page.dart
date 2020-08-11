import 'package:flutter/material.dart';
import 'package:flutterapp/app/home/task_page/screens/pick_nickname.dart';
import 'package:provider/provider.dart';


//screens
import './screens/new_user_screen.dart';
import './screens/loading_screen.dart';
import './screens/todo_app.dart';
import './screens/todos_screen.dart';

//providers
import 'package:flutterapp/app/home/task_page/providers/home.dart';


class TaskPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=>HomeProvider(),),
      ],
      child: Consumer<HomeProvider>(
        builder: (context,homeProvider,widget){
          return MaterialApp(
            color: Colors.white, 
            debugShowCheckedModeBanner: false,
            title: 'Daily Task',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: homeProvider.isNewUser?  ToDo() : FutureBuilder(
              future: homeProvider.tryToGetData(),
              builder: (context,result){
                if(result.connectionState == ConnectionState.waiting){
                  return LoadingScreen();
                }else{
                  return PickNickname();
                }
              },
            ),
            routes: {
              ToDosScreen.routeName:(ctx)=>ToDosScreen()
            },
          );
        },
      ),
    );
  }
}