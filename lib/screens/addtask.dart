import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/widgets/custom_button.dart';

import '../model/google_signin_model.dart';
import '../shared/widget.dart';
import '../utils/login_methods.dart';
import 'home.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? uid = '';
  @override
  void initState() {
    getuserdata();
    super.initState();
  }

  Future<GoogleSignInModel> googleSignInProcess(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    String? token = googleAuth?.idToken;
    GoogleSignInModel socialGoogleUser = GoogleSignInModel(
        displayName: googleUser?.displayName,
        email: googleUser?.email,
        photoUrl: googleUser?.photoUrl,
        id: googleUser?.id,
        token: token);

    Fluttertoast.showToast(
        msg: "Welcome", backgroundColor: Colors.green, textColor: Colors.white);

    return socialGoogleUser;
  }

  getuserdata() async {
    googleSignInProcess(context).then((value) {
      setState(() {
        uid = value.id.toString();
      });
    });
  }

  addtasktofirebase() async {
    // final FirebaseUser user = await auth.currentUser();
    await googleSignInProcess(context).then((value) {
      setState(() {
        uid = value.id.toString();
      });
    });
    DateTime time = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(time);
    DateTime myDateTime = myTimeStamp.toDate();
    //  var firebaseUser = await FirebaseAuth.instance.currentUser();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(uid)
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': dateController.text.toString(),
      'timestamp': time.toString()
    });
    Fluttertoast.showToast(msg: 'Data Added Successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new thing'),
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            color: themecolor,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundColor: Colors.blue,
                    child: Image.asset(
                      "assets/taskimg.png",
                      scale: 10,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          labelText: 'Enter Title',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1))),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          labelText: 'Enter Description',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    //validator:
                    //  RequiredValidator(errorText: "Date of Birth Required"),
                    decoration: InputDecoration(
                        hintText: '12/12/2021',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.black12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        )),

                    style: TextStyle(color: Colors.black),
                    onTap: () {
                      _selectDate(context);
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    controller: dateController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please select To date ";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                SocialLoginButton(
                  height: 50,
                  icon: "assets/taskimg.png",
                  buttonColor: Colors.blue,
                  buttonText: 'Add things',
                  onPressed: () {
                    addtasktofirebase();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                )
              ],
            )),
      ),
    );
  }

//pick up function
  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }
}
