import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';


class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int totalVotes = 0;

  List<int> votes = List<int>.filled(8, 0);

  List<String> names = List<String>.filled(8, '');

  List<String> vicenames= List<String>.filled(8, '');

  List<String> imgs = ["images/c1.jpeg","images/c2.jpeg","images/c3.jpeg","images/c4.jpeg","images/c5.jpeg","images/c6.jpeg","images/c7.jpeg"];

  @override
  void initState() {
    super.initState();
    get_total();
    listenToValueChanges();
  }

  Future<void> get_total() async {
    try {
      final ref = FirebaseDatabase.instance.ref('/');
      final snapshot = await ref.child('total_votes').get();
      final snapshot2 = await ref.child('candidates').get();
      final snapshot3 = await ref.child('vice_can').get();

      if (snapshot.exists) {
        setState(() {
          totalVotes = snapshot.value as int;
        });
      }
      if (snapshot2.exists) {
        setState(() {
          names = snapshot2.value.toString().split(',');
          vicenames = snapshot3.value.toString().split(',');

        });
      } else {
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
        List<int> temp_int = event.snapshot.value.toString().split(',').map(int.parse).toList();
        setState(() {
          votes = temp_int;
        });
      } else {
        print('No data found.');
      }
    });
  }

  Widget tile(String name, int vote, String img,String vname) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(radius: 40, backgroundImage: AssetImage(img)),
            ),
            Expanded(
              child: Text(
                "$name\n$vname",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("VOTES", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text("$vote", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int voted = votes.reduce((a, b) => a + b);
    int remaining = totalVotes - voted;
    return  Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Center(child: Text("ELECTION RESULTS", style: TextStyle(color: Colors.white, fontSize: 30))),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView(
        children:[ Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: List.generate(7, (index) {
                return tile(names[index], votes[index], imgs[index],vicenames[index]);
              }),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Total Votes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("$totalVotes", style: TextStyle(fontSize: 40, color: Colors.blueGrey)),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Voted", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("$voted", style: TextStyle(fontSize: 40, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Remaining Votes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("$remaining", style: TextStyle(fontSize: 40, color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ],
      ),
    ); ;
  }
}
