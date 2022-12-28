import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_finder/persistent/persistent.dart';
import 'package:job_finder/services/global_variables.dart';
import 'package:job_finder/widgets/bottom_nav_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  int index = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.deepOrange.shade400,
        backgroundColor: Colors.blueAccent,
        buttonBackgroundColor: Colors.deepOrange.shade300,
        height: 50,
        index: index,
        items:const  [
           Icon(
            Icons.list,
            size: 19,
            color: Colors.black,
          ),
           Icon(
            Icons.search,
            size: 19,
            color: Colors.black,
          ),  Icon(
            Icons.add,
            size: 19,
            color: Colors.black,
          ),  Icon(
            Icons.person_pin,
            size: 19,
            color: Colors.black,
          )
        ],
        animationDuration:const Duration(milliseconds: 300),
        animationCurve: Curves.bounceInOut,
        onTap: (idx){

          setState(() {
            index = idx;
          });

        },
      ),
          body: pages[index],
    );
  }
}
