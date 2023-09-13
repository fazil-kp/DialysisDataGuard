import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateDonor extends StatefulWidget {
  const UpdateDonor({super.key});

  @override
  State<UpdateDonor> createState() => _UpdateDonorState();
}

class _UpdateDonorState extends State<UpdateDonor> {
  final List bloodGroups = ['A+', 'A-', 'B-', 'B+', 'O-', 'O+', 'AB+', 'AB-'];
  String? selectedGroup;
  final CollectionReference donor =
      FirebaseFirestore.instance.collection('donor');

  TextEditingController donorName = TextEditingController();
  TextEditingController donorPhone = TextEditingController();
  void updateDonor(docId){
    final data = {
      'name' : donorName.text,
      'phone' : donorPhone.text,
      'group' : selectedGroup,
    };
    donor.doc(docId).update(data).then((value) => Navigator.pop(context));

  }

  @override
  Widget build(BuildContext context) {
    // update
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    donorName.text = args['name'];
    donorPhone.text = args['phone'];
    selectedGroup = args['group'];
    final docId = args ['id'];


    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Details"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: donorName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Patient Name"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: donorPhone,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Phone Number"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                value: selectedGroup,
                decoration: InputDecoration(
                  label: Text("Select Blood Group"),
                ),
                items: bloodGroups
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedGroup = value as String?;
                },
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  const Size(double.infinity, 50),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                updateDonor(docId);
              },
              child: const Text(
                "Update",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
