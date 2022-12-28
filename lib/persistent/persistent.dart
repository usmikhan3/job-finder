import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_finder/services/global_variables.dart';

class Persistent{
  static List<String> jobCategoryList = [
    'Architecture and Construction',
    'Education and Training',
    'Development - Porgramming',
    'Business',
    'Information Technology',
    'Human Resources',
    'Design',
    'Accounting',
  ];

  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    name = userDoc.get('name');
    userImage = userDoc.get('userImage');
    location = userDoc.get('location');
  }

}