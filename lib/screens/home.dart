import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/screens/addtask.dart';
import 'package:todo_firebase/screens/description.dart';

import '../utils/login_methods.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';
  @override
  void initState() {
    // getuid();
    getuserdata();
    super.initState();
  }

  String name = '';
  String email = '';
  var responseValue;
  bool isLoggedIn = false;
  getuserdata() async {
    await googleSignInProcess(context).then((value) {
      setState(() {
        isLoggedIn = true;
        responseValue = value;
        name = value.displayName!;
        email = value.email!;
        uid = value.id.toString();
      });
    });
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Things :$name',
          style: GoogleFonts.lato(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut().then((value) {
                  setState(() {
                    isLoggedIn = false;
                    responseValue = value;
                  });
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [Text("Home")],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        //color: Colors.red,
        child:
            //Center(child: Text(email)),
            StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null) {
              return new Center(
                child: Text("No data Kindly Add Notes"),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return new Center(
                child: Text("No Data "),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Text("No data Kindly Add Notes"),
              );
            } else {
              final docs = snapshot.data!.docs;
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/imagebg.jpg"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Center(
                            child: Text(
                              "JUST \n YOUR \n THINGS",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Inbox",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: docs != null ? docs.length : 0,
                            itemBuilder: (context, index) {
                              String time = (docs[index]['time']);
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Description(
                                                title: docs[index]['title'],
                                                description: docs[index]
                                                    ['description'],
                                              )));
                                },
                                child: Container(
                                  height: 90,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 90,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          radius: 30,
                                          child: Image.asset(
                                            "assets/taskimg.png",
                                            scale: 15,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  docs[index]['title'],
                                                  style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(time,
                                                    style: GoogleFonts.lato(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)))
                                          ]),
                                      Container(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(uid)
                                                  .collection('mytasks')
                                                  .doc(uid)
                                                  .delete();

                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Task Deleted Successfully');
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        // // color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTask()));
          }),
    );
  }
}
