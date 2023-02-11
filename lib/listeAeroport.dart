/*
import 'package:flutter/material.dart';


class listeAeroport extends StatelessWidget{
  const listeAeroport({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController( //controller for TabBar
        length: 2, //lenght of tabs in TabBar
        child: MaterialApp(
        home: Appbar(),
        )
    );
  }
}

class Appbar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
        title:const Text("Title of App"), //title of app
    backgroundColor: Colors.redAccent, //background color of app bar
    brightness: Brightness.dark, //redAccent is darker color so set brightness to dark
    elevation: 5.0, //elevation value of appbar
    bottom: TabBar( //tabbar at bottom of appbar
    onTap: (index){
    print("selected tab is $index");
    },
    tabs: const [
    Tab(icon: Icon(Icons.home)),
    Tab(icon: Icon(Icons.send))
    //more tabs here
    ],
    ),
          actions: [ //actions widget in appbar
            IconButton(
                icon: Icon(Icons.camera),
                onPressed: (){
                  //code to execute when this button is pressed
                }
            ),

            IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  //code to execute when this button is pressed
                }
            ),
            //more widgets to place here
          ],
        ),

        drawer: const Drawer(), //drawer on scaffold, it will create menu icon on appbar

        body: Center( //content body on scaffold
            child: Text("AppBar example")
        )
    );
  }
}*/
