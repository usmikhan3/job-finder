import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:job_finder/views/jobs/job_screen.dart';
import 'package:job_finder/views/search/search_company_screen.dart';

class BottomNavBar extends StatelessWidget {
  int index = 0;

   BottomNavBar({required this.index});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 50,
      index: index,
      items:const [
        Icon(
          Icons.list,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.black,
        ),
      ],
      animationDuration:const Duration(milliseconds: 300),
      animationCurve: Curves.bounceInOut,
      onTap: (index){
        if(index == 0 ){
          JobScreen();
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>JobScreen(),),);
        }else if(index == 1){
          AllWorkerScreen();
          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> AllWorkerScreen(),),);
        }
      },
    );
  }
}
