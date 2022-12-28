import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_finder/user_state.dart';
import 'package:job_finder/views/login/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    "Job Finder is being initialized",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Signatra"),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    "An Error has een occurred.",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Signatra"),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Job Finder",
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primarySwatch: Colors.blue,
            ),
            home: UserState(),
          );
        });
  }
}
