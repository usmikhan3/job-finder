import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_finder/persistent/persistent.dart';
import 'package:job_finder/views/home/home_screen.dart';
import 'package:job_finder/views/jobs/job_screen.dart';
import 'package:job_finder/views/login/login_screen.dart';



class UserState extends StatefulWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.data == null) {
            print("user is not logged in yet");
            return LoginScreen();
          } else if (userSnapshot.hasData) {
            print("user is already logged in");
            return HomeScreen();
          }
          else if(userSnapshot.hasError){
            return const Scaffold(
              body: Center(
                child: Text("An error has been occoured, Try again later"),
              ),
            );
          }
          else if(userSnapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        });
  }
}
