import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User currentUser;
  late final String documentId;
  late final String uid;
  late final int percentage;
  final DateTime currentDate = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot> _historyStream;

  @override
  void initState() {
    // TODO: implement initState
    currentUser = auth.currentUser!;
    uid = currentUser.uid;
    DateTime currentDate = DateTime.now();
    _historyStream = FirebaseFirestore.instance
        .collection('history')
        .where("userId", isEqualTo: uid)
        //.where("date", isGreaterThanOrEqualTo: 1622961000)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Your Charging History',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Day',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Percentage',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: _historyStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return new Table(
                    border: TableBorder.all(
                      width: 2.0,
                      color: Colors.pink,
                      style: BorderStyle.solid,
                    ),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              " ${data['date'].toDate().toString()}",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(" ${data['percentage']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0)),
                          )
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
