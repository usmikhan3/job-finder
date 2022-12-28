import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:job_finder/persistent/persistent.dart';
import 'package:job_finder/services/global_variables.dart';
import 'package:job_finder/user_state.dart';
import 'package:job_finder/views/login/login_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SameUserProfileScreen extends StatefulWidget {


  const SameUserProfileScreen({Key? key}) : super(key: key);

  @override
  State<SameUserProfileScreen> createState() => _SameUserProfileScreenState();
}

class _SameUserProfileScreenState extends State<SameUserProfileScreen> {
  String name='';
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;


  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        return;
      } else {

        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          imageUrl = userDoc.get('userImage');
          phoneNumber = userDoc.get('phoneNumber');
          Timestamp joinedTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        // User? user = _auth.currentUser;
        // String _uid = user!.uid;
        // setState(() {
        // _uid = widget.userId;
        // });

        print(name);
        print(email);
      }
    }on FirebaseException catch (e) {
      print(e.message.toString());
    } finally {
      _isLoading = false;
    }
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }


  Widget _contactBy({required IconData icon, required Color color, required VoidCallback fct}){
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child:  CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: fct,
        ),
      ),

    );
  }

  void _logout() {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    )),
              ],
            ),
            content: const Text(
              "Do you want to log out? ",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>UserState()));
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;

                    _auth.signOut().then((value) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                    });
                  },
                  child:
                  const Text("Yes", style: TextStyle(color: Colors.green))),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();

  }



  void _openWhatsappChat() async{
    var  url = 'https://wa.me/$phoneNumber?text=Hello';
    launchUrlString(url);

  }

  void _mailTo() async{
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query:
      'subject=Write Subject Here&body=Hello, please write details.',
    );
    final url = params.toString();
    launchUrlString(url);

  }

  void _callPhoneNumber() async{
    var  url = 'tel://$phoneNumber';
    launchUrlString(url);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.deepOrange.shade300,
                Colors.blueAccent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Stack(
                children: [
                  Card(
                    color: Colors.white10,
                    margin: const EdgeInsets.all(30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),



                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Account Information: ",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(
                                icon: Icons.email, content: email),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(
                                icon: Icons.person, content: name),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: userInfo(
                                icon: Icons.phone, content: phoneNumber),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
  Center(
                            child: MaterialButton(
                              color: Colors.black,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(13),
                              ),
                              onPressed: () {
                                _logout();
                              },
                              child: Padding(
                                padding:const  EdgeInsets.symmetric(vertical: 14),
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:const [
                                    Text(
                                      "Logout",
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,fontFamily: 'Signatra',
                                        fontWeight: FontWeight.bold,),
                                    ),
                                    SizedBox(width: 5,),
                                    Icon(Icons.logout,color: Colors.white,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                         Container(),
                          const SizedBox(
                            height: 10,
                          ),

                        ],
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.width * 0.26,
                        width: size.width * 0.26,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 8,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            image: DecorationImage(
                                image: NetworkImage(
                                    userImage == null ?
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                                        :
                                    userImage!
                                ),
                                fit: BoxFit.fill
                            )
                        ),

                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
