import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_finder/views/jobs/job_screen.dart';
import 'package:job_finder/views/jobs/upload_job_screen.dart';
import 'package:job_finder/views/profile/profile_screen.dart';
import 'package:job_finder/views/profile/same_user_profile_screen.dart';
import 'package:job_finder/views/search/search_company_screen.dart';
import 'package:job_finder/views/search/search_job_screen.dart';

String loginUrlImage = 'https://wallpaperaccess.com/full/643367.jpg';
String signUpUrlImage = 'https://www.wallpaperuse.com/wallp/49-494529_m.jpg';
String forgotPassUrlImage = 'https://www.wallpaperuse.com/wallp/49-494529_m.jpg';

String? name = '';
String? userImage = '';
String? location = '';





final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
final String uid = user!.uid;

List pages = [
  JobScreen(),
  AllWorkerScreen(),
  UploadJobNowScreen(),
  SameUserProfileScreen(),



];
