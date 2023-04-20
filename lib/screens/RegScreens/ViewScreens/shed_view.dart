import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:home_login/screens/RegScreens/ViewScreens/flock_view.dart';
import 'package:home_login/screens/RegScreens/shedReg_screen.dart';
import 'package:get/get.dart';
import 'package:home_login/screens/selection_screen.dart';
import '../../../Colors.dart';
import '../../../net/flutter_fire.dart';
import 'package:home_login/screens/UserRegScreens/signin_screen.dart';

class ShedScreen extends StatefulWidget {
  final String farmID;
  final String branchName, farmName;
  final String branchID;
  const ShedScreen(this.branchName, this.farmName, this.farmID, this.branchID,
      {Key? key})
      : super(key: key);
  //const ShedScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ShedScreen createState() =>
      _ShedScreen(branchName, farmName, farmID, branchID);
}

class _ShedScreen extends State<ShedScreen> {
  String branchName, farmName;
  String farmID;
  String branchID;
  _ShedScreen(this.branchName, this.farmName, this.farmID, this.branchID);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(branchName + " branch sheds".tr),
          backgroundColor: mPrimaryColor,
          //foregroundColor: Colors.amber,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.language),
              onPressed: () {
                builddialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelectionScreen()));
              },
            ),
          ]),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Farmers')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Shed')
                  .where('BranchID', isEqualTo: branchID)
                  .where('FarmID', isEqualTo: farmID)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlockScreen(
                                    document['ShedName'],
                                    branchName,
                                    farmName,
                                    farmID,
                                    branchID,
                                    document.id)),
                          );
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 25.0, right: 25),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.5),
                                color: Colors.white,
                                //color: mSecondColor,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(5, 10),
                                      color: Colors.grey,
                                      spreadRadius: 2,
                                      blurRadius: 5),
                                ],
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, left: 0, right: 0),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              12,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.5),
                                        color: mSecondColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text(
                                            " ${document['ShedName']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              openDialog(document.id, document['ShedName']);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.file_open,
                                              color: Colors.white,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              openDialogDelete(document.id,document['ShedName']);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                        ],
                                      ))),
                            )));
                  }).toList(),
                );
              }),
        ),
      ),

      floatingActionButtonLocation: null,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30,bottom: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: mBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: mPrimaryColor),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ShedRegScreen(branchID, farmID);
                },
              ),
            );
          },
          child: Container(

            alignment: Alignment.center,
            width: double.infinity,
            height: 20,
            child: Text(
              "Add New Shed",
              style: TextStyle(
                color: mPrimaryColor,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),


    );
  }

  Future openDialog(String id, String shedName) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Edit Shed Details".tr),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(hintText: shedName),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  //_controller.text = location;
                  await updateShed(id, _controller.text);
                  _controller.clear();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: Text("Change".tr))
          ],
        ),
      );

  Future openDialogDelete(String id, String shedName) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Want to delete ".tr + shedName + " shed details?".tr),
          actions: [
            TextButton(
                onPressed: () async {
                  // delete function here
                  removeShed(id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Yes".tr,
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text(
                "No".tr,
                style: TextStyle(color: Colors.green),
              ),
            )
          ],
        ),
      );
}
