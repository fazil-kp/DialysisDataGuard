import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  void deleteDonor(docId){
    donor.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DialysisDataGuard"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.red,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: StreamBuilder(
          stream: donor.orderBy('name').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot donorSnap = snapshot.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 194, 193, 193),
                            blurRadius: 10,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 30,
                                child: Text(
                                  donorSnap['group'],
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                donorSnap['name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                donorSnap['phone'].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/update",
                                      arguments: {
                                        //updating here
                                        'name': donorSnap['name'],
                                        'phone': donorSnap['phone'].toString(),
                                        'group': donorSnap['group'],
                                        'id': donorSnap.id,
                                      });
                                },
                                icon: Icon(Icons.edit),
                                iconSize: 30,
                                color: Colors.blue,
                              ),
                              IconButton(
                                onPressed: () {
                                  deleteDonor(donorSnap.id);
                                },
                                icon: Icon(Icons.delete),
                                iconSize: 30,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
