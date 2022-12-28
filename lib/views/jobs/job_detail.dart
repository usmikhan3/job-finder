import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_finder/services/global_methods.dart';
import 'package:job_finder/services/global_variables.dart';
import 'package:job_finder/views/home/home_screen.dart';
import 'package:job_finder/widgets/comment_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

class JobDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobId;

  const JobDetailScreen(
      {Key? key, required this.uploadedBy, required this.jobId})
      : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  String? postedDate;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadLineAvailable = false;
  bool _isCommenting = false;
  bool showComment = false;

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }

    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobId)
        .get();

    if (jobDatabase == null) {
      return;
    } else {
      setState(() {
        jobCategory = jobDatabase.get('jobCategory');
        jobTitle = jobDatabase.get('jobTitle');
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('DeadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('jobDeadline');
        locationCompany = jobDatabase.get('location');
        emailCompany = jobDatabase.get('email');
        applicants = jobDatabase.get('applicants');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });

      var date = deadlineDateTimeStamp!.toDate();
      isDeadLineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getJobData();
    super.initState();
  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
          'subject=Applying for $jobTitle&body=Hello, please attach Resume/CV File.',
    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef =
        FirebaseFirestore.instance.collection('jobs').doc(widget.jobId);

    docRef.update({
      'applicants': applicants + 1,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange.shade300,
                      Colors.blueAccent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.2, 0.9]),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              icon: const Icon(
                Icons.close,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              jobTitle == null ? '' : jobTitle!,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.grey,
                                  ),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      userImageUrl == null
                                          ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
                                          : userImageUrl!,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      authorName == null ? '' : authorName!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      locationCompany == null
                                          ? ''
                                          : locationCompany!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          dividerWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                applicants.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              const Text(
                                'Applicants',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                Icons.how_to_reg_sharp,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          FirebaseAuth.instance.currentUser!.uid !=
                                  widget.uploadedBy
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    dividerWidget(),
                                    const Text(
                                      'Recruitment',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            User? user = _auth.currentUser;
                                            final _uid = user!.uid;
                                            if (_uid == widget.uploadedBy) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('jobs')
                                                    .doc(widget.jobId)
                                                    .update({
                                                  'recruitment': true,
                                                });
                                              } on FirebaseException catch (e) {
                                                GlobalMethod.showErrorDialog(
                                                    error: e.message.toString(),
                                                    ctx: context);
                                              }
                                            } else {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      'You cannot perform this action',
                                                  ctx: context);
                                            }
                                            getJobData();
                                          },
                                          child: const Text(
                                            "ON",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: recruitment == true ? 1 : 0,
                                          child: const Icon(
                                            Icons.check_box,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            User? user = _auth.currentUser;
                                            final _uid = user!.uid;
                                            if (_uid == widget.uploadedBy) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('jobs')
                                                    .doc(widget.jobId)
                                                    .update({
                                                  'recruitment': false,
                                                });
                                              } on FirebaseException catch (e) {
                                                GlobalMethod.showErrorDialog(
                                                    error: e.message.toString(),
                                                    ctx: context);
                                              }
                                            } else {
                                              GlobalMethod.showErrorDialog(
                                                  error:
                                                      'You cannot perform this action',
                                                  ctx: context);
                                            }
                                            getJobData();
                                          },
                                          child: const Text(
                                            "OFF",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: recruitment == false ? 1 : 0,
                                          child: const Icon(
                                            Icons.check_box,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          dividerWidget(),
                          const Text(
                            "Job Description",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            jobDescription == null ? '' : jobDescription!,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          dividerWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              isDeadLineAvailable
                                  ? 'Actively Recruiting, Send Cv/Resume:'
                                  : 'Deadline Passed away.',
                              style: TextStyle(
                                color: isDeadLineAvailable
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Center(
                            child: MaterialButton(
                              onPressed: () {
                                applyForJob();
                              },
                              color: Colors.blueAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Text(
                                  "Easy Apply Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          dividerWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Uploaded on: ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                postedDate == null ? '' : postedDate!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Deadline date: ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                deadlineDate == null ? '' : deadlineDate!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          dividerWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _isCommenting
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: TextField(
                                          controller: _commentController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          maxLength: 200,
                                          keyboardType: TextInputType.text,
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.pink),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  if (_commentController
                                                          .text.length <
                                                      7) {
                                                    GlobalMethod.showErrorDialog(
                                                        error:
                                                            'Comment cannot be less than 7 characters',
                                                        ctx: context);
                                                  } else {
                                                    final _generatedId =
                                                        Uuid().v4();
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('jobs')
                                                        .doc(widget.jobId)
                                                        .update({
                                                      'jobComments': FieldValue
                                                          .arrayUnion([
                                                        {
                                                          'userId': FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid,
                                                          'commentId':
                                                              _generatedId,
                                                          'name': name,
                                                          'userImageUrl':
                                                              userImage,
                                                          'commentBody':
                                                              _commentController
                                                                  .text,
                                                          'time':
                                                              Timestamp.now(),
                                                        }
                                                      ]),
                                                    });
                                                    await Fluttertoast.showToast(
                                                        msg:
                                                            "Your comment has been added",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        fontSize: 16.0);
                                                    _commentController.clear();
                                                  }
                                                  setState(() {
                                                    showComment = true;
                                                  });
                                                },
                                                color: Colors.blueAccent,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Text(
                                                  "Post",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isCommenting =
                                                      !_isCommenting;
                                                  showComment = false;
                                                });
                                              },
                                              child: const Text(
                                                "Cancel",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isCommenting = !_isCommenting;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add_comment,
                                          color: Colors.blueAccent,
                                          size: 40,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showComment = true;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: Colors.blueAccent,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          showComment == false
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('jobs')
                                        .doc(widget.jobId)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        if (snapshot.data == null) {
                                          return const Center(
                                            child: Text(
                                              "No Comments for this job yet",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          );
                                        }
                                      }
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics:const  NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return CommentWidget(
                                            commentId: snapshot.data!['jobComments'][index]['commentId'],
                                            commenterId: snapshot.data!['jobComments'][index]['userId'],
                                            commenterName: snapshot.data!['jobComments'][index]['name'],
                                            commentBody: snapshot.data!['jobComments'][index]['commentBody'],
                                            commenterImageUrl: snapshot.data!['jobComments'][index]['userImageUrl'],
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount: snapshot.data!['jobComments'].length,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
