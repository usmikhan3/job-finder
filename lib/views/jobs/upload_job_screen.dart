import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_finder/persistent/persistent.dart';
import 'package:job_finder/services/global_methods.dart';
import 'package:job_finder/services/global_variables.dart';
import 'package:uuid/uuid.dart';

class UploadJobNowScreen extends StatefulWidget {
  const UploadJobNowScreen({Key? key}) : super(key: key);

  @override
  State<UploadJobNowScreen> createState() => _UploadJobNowScreenState();
}

class _UploadJobNowScreenState extends State<UploadJobNowScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobCategoryController =
      TextEditingController(text: 'Select Job Category');
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _jobDeadLineController =
      TextEditingController(text: '');

  bool _isLoading = false;

  DateTime? picked;
  Timestamp? deadLineDateTimeStamp;

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required VoidCallback fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: fct,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return ' Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          maxLines: valueKey == 'JobDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black54,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              "Job Category: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _jobCategoryController.text =
                            Persistent.jobCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _pickDateDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _jobDeadLineController.text =
            '${picked!.year}-${picked!.month}-${picked!.day}';
        deadLineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final jobId = Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      if (_jobDeadLineController.text.isEmpty ||
          _jobCategoryController.text == 'Select Job Category' ||
          _jobTitleController.text.isEmpty ||
          _jobDescriptionController.text.isEmpty) {
        GlobalMethod.showErrorDialog(
          error: "Please fill all the fields.",
          ctx: context,
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).set({
          "jobId": jobId,
          "uploadedBy": _uid,
          "email": user.email,
          "jobCategory": _jobCategoryController.text,
          "jobTitle": _jobTitleController.text,
          "jobDescription": _jobDescriptionController.text,
          "jobDeadline": _jobDeadLineController.text,
          "DeadlineDateTimeStamp": deadLineDateTimeStamp,
          "jobComments": [],
          "recruitment": true,
          "createdAt": Timestamp.now(),
          "name": name,
          "userImage": userImage,
          "location": location,
          "applicants": 0,
        });
        await Fluttertoast.showToast(
          msg: "The Job has been successfully posted.",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.grey,
          fontSize: 16.0,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = 'Select Job Category';
          _jobDeadLineController.text = '';
        });
      } on FirebaseException catch (e) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(
          error: e.message.toString(),
          ctx: context,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Its not valid');
    }
  }



  // @override
  // void initState() {
  //   super.initState();
  //   getMyData();
  //
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _jobDeadLineController.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
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
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Card(
                color: Colors.white10,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Please fill all fields",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Signatra',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textTitles(label: "Job Category: "),
                              _textFormField(
                                controller: _jobCategoryController,
                                enabled: false,
                                fct: () {
                                  _showTaskCategoriesDialog(size: size);
                                },
                                valueKey: 'JobCategory',
                                maxLength: 100,
                              ),
                              _textTitles(label: "Job Title: "),
                              _textFormField(
                                controller: _jobTitleController,
                                enabled: true,
                                fct: () {},
                                valueKey: 'JobTitle',
                                maxLength: 100,
                              ),
                              _textTitles(label: "Job Description: "),
                              _textFormField(
                                controller: _jobDescriptionController,
                                enabled: true,
                                fct: () {},
                                valueKey: 'JobDescription',
                                maxLength: 100,
                              ),
                              _textTitles(label: "Job Deadline Date: "),
                              _textFormField(
                                controller: _jobDeadLineController,
                                enabled: false,
                                fct: () {
                                  _pickDateDialog();
                                },
                                valueKey: 'Deadline',
                                maxLength: 100,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : MaterialButton(
                                  onPressed: () {
                                    _uploadTask();
                                  },
                                  color: Colors.black,
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Post Now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                              fontFamily: "Signatra"),
                                        ),
                                        SizedBox(
                                          width: 9,
                                        ),
                                        Icon(
                                          Icons.upload_file,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
