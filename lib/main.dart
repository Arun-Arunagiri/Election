import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async{
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Election',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int totalVotes = 0;
  List<int> votes = [0,0,0,0,0,0,0,0];
  List<String> names = [];
  String? downloadURL;


  @override
  void initState() {
    super.initState();
    get_total();
    listenToValueChanges();
  }



  Widget tile(String name, int vote) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 8),
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width / 3.1,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 40,
              ),
            ),
            Expanded(child: Text(name, style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  Text("VOTES", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text("$vote", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> get_total() async {
    try {
      final ref = FirebaseDatabase.instance.ref('/');
      final snapshot = await ref.child('total_votes').get();
      final snapshot2 = await ref.child('candidates').get();
      if (snapshot.exists) {
        setState(() {
          totalVotes = snapshot.value as int;
        });
      }
      if (snapshot2.exists){
        setState(() {
          names = snapshot2.value.toString().split(',');
          print(names);
        });
      }
      else {
        print('Server Error');
      }
    } catch (e) {
      print('Error fetching total votes: $e');
    }
  }



  void listenToValueChanges() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('votes');

    ref.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        print('Data changed: ${event.snapshot.value}');
        String temp = event.snapshot.value.toString();
        List<int> temp_int = temp.split(',').map(int.parse).toList();
        setState(() {
          votes = temp_int;
        });
      } else {
        print('No data found.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    int voted = votes[0]+votes[1]+votes[2]+votes[3]+votes[4]+votes[5]+votes[6];
    int remaining = totalVotes - voted;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Center(child: Text("ELECTION RESULTS", style: TextStyle(color: Colors.white, fontSize: 30))),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  tile(names[0], votes[0]),
                  tile(names[1], votes[1]),
                  tile(names[2], votes[2]),
                  tile(names[3], votes[3]),
                ],
              ),
              Column(
                children: [
                  tile(names[4], votes[4]),
                  tile(names[5], votes[5]),
                  tile(names[6], votes[6]),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Total Votes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("$totalVotes", style: TextStyle(fontSize: 45, color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Voted", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("$voted", style: TextStyle(fontSize: 45, color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Remaining Votes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("$remaining", style: TextStyle(fontSize: 45, color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


