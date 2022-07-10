import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_login/constants.dart';
import 'package:home_login/screens/griddashboard.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ViewScreen extends StatefulWidget {
   ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}



class _ViewScreenState extends State<ViewScreen> {

    List<ChartData> chartData = <ChartData>[];





    //List<PoultryData> weightDataCurrent=[PoultryData(0, 0)];
     List<PoultryData> weightDataCurrent= [];


    //this is for testing
   final List<PoultryData> weightDataCobb500 =[
     PoultryData(0,  42),
     PoultryData(1,  63),
     PoultryData(2,  74),
     PoultryData(3,  90),
     PoultryData(4,  109),
     PoultryData(5,  134),
     PoultryData(6,  163),
     PoultryData(7,  193),
     PoultryData(8,  228),
     PoultryData(9,  269),
     PoultryData(10, 313),
     PoultryData(11, 362),
     PoultryData(12, 414),
     PoultryData(13, 469),
     PoultryData(14, 528),
     PoultryData(15, 589),
     PoultryData(16, 654),
     PoultryData(17, 722),
     PoultryData(18, 792),
     PoultryData(19, 865),
     PoultryData(20, 941),
     PoultryData(21, 1018),
     PoultryData(22, 1098),
     PoultryData(23, 1180),
     PoultryData(24, 1264),
     PoultryData(25, 1349),
     PoultryData(26, 1436),
     PoultryData(27, 1525),
     PoultryData(28, 1615),
     PoultryData(29, 1706),
     PoultryData(30, 1798),
     PoultryData(31, 1892),
     PoultryData(32, 1986),
     PoultryData(33, 2081),
     PoultryData(34, 2177),
     PoultryData(35, 2273),
     PoultryData(36, 2369),
     PoultryData(37, 2466),
     PoultryData(38, 2563),
     PoultryData(39, 2661),
     PoultryData(40, 2758),
     PoultryData(41, 2855),
     PoultryData(42, 2952),
     PoultryData(43, 3049),
     PoultryData(44, 3145),
     PoultryData(45, 3240),

   ];

   //this is for testing
  final List<PoultryData> weightDataStrain =[
    PoultryData(0,  42),
    PoultryData(1,  63),
    PoultryData(2,  74),
    PoultryData(3,  90),
    PoultryData(4,  109),
    PoultryData(5,  134),
    PoultryData(6,  163),
    PoultryData(7,  193),
    PoultryData(8,  228),
    PoultryData(9,  269),
    PoultryData(10, 313),
  ];


/*
   final List<PoultryData> weightDataCurrent =[
     PoultryData(0,  45),
     PoultryData(1,  54),
     PoultryData(2,  66),
     PoultryData(3,  70),
     PoultryData(4,  86),
     PoultryData(5,  115),
     PoultryData(6,  146),
     PoultryData(7,  180),
     PoultryData(8,  220),
     PoultryData(9,  280),
     PoultryData(10, 330),
   ];
*/




  final List<PoultryData> feedDataStrain =[

    PoultryData(8,  37),
    PoultryData(9,  43),
    PoultryData(10, 50),

  ];

   final List<PoultryData> feedDataCurrent =[

     PoultryData(8,  44),
     PoultryData(9,  55),
     PoultryData(10, 70),

   ];

  @override
  Widget build(BuildContext context) {


    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;





    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Poultry Analysis'),
            backgroundColor: mPrimaryColor,

          ),
        body: ListView(


          children: [


            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Farmers")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('flock')
                    .doc(args.flockID)
                    .collection('BodyWeight')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {


                    List<String> flockItems;
                    //late final List <ChartData> weightDataCurrent;

                    //final Map<String, int> someMap = {

                    //};
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      DocumentSnapshot snap = snapshot.data!.docs[i];

                      double amount = -1;
                      String date;
                      try {
                        amount = snapshot.data?.docs[i]['Average_Weight'];
                        date = snapshot.data!.docs[i].id;
                        print(snapshot.data!.docs[i].id);
                        print(i);
                        print(amount);
                        print('');
                        weightDataCurrent.add(PoultryData(i, amount));

                        amount=0.0;
                      } catch (e) {
                        amount = -1;
                      }

                    }
                    //print(flockItems);
                    return Container(
                      height: 400,
                      margin: EdgeInsets.all(10),
                      child:  SfCartesianChart(
                        legend: Legend(isVisible: true, position :LegendPosition.bottom ),

                        title: ChartTitle(text: 'Weight performance'),
                        series: <ChartSeries>[
                          LineSeries<PoultryData,int>(
                            legendItemText: 'Active Batch',
                            color: Colors.deepOrange ,
                            dataSource: weightDataCurrent,

                            xValueMapper: (PoultryData chick, _)=> chick.day,
                            yValueMapper: (PoultryData chick, _)=> chick.amount,

                          ),
                          LineSeries<PoultryData,int>(
                            legendItemText: 'Equivalent ideal strain',
                            color: Colors.blue ,
                            dataSource: weightDataCobb500.sublist(0,10),
                            xValueMapper: (PoultryData chick, _)=> chick.day,
                            yValueMapper: (PoultryData chick, _)=> chick.amount,

                          ),
                        ],
                      ),

                    );
                  }
                }),



           /*
            Container(
              height: 400,
              margin: EdgeInsets.all(10),
              child:  SfCartesianChart(
                legend: Legend(isVisible: true, position :LegendPosition.bottom ),

                title: ChartTitle(text: 'Weight performance'),
                series: <ChartSeries>[
                  LineSeries<PoultryData,int>(
                    legendItemText: 'Active Batch',
                    color: Colors.deepOrange ,
                    dataSource: weightDataCurrent,

                    xValueMapper: (PoultryData chick, _)=> chick.day,
                    yValueMapper: (PoultryData chick, _)=> chick.amount,

                  ),
                  LineSeries<PoultryData,int>(
                    legendItemText: 'Equivalent ideal strain',
                    color: Colors.blue ,
                    dataSource: weightDataCobb500.sublist(0,10),
                    xValueMapper: (PoultryData chick, _)=> chick.day,
                    yValueMapper: (PoultryData chick, _)=> chick.amount,

                  ),
                ],
              ),
            ),
            */


            Container(
              height: 400,
              margin: EdgeInsets.all(10),
              child:  SfCartesianChart(
                legend: Legend(isVisible: true, position :LegendPosition.bottom ),

                title: ChartTitle(text: 'Feed Performance'),
                series: <ChartSeries>[
                  LineSeries<PoultryData,int>(
                    legendItemText: 'Active Batch',
                    color: Colors.deepOrange ,
                    dataSource: feedDataCurrent,
                    xValueMapper: (PoultryData chick, _)=> chick.day,
                    yValueMapper: (PoultryData chick, _)=> chick.amount,

                  ),
                  LineSeries<PoultryData,int>(

                    legendItemText: 'Equivalent ideal strain',
                    color: Colors.blue ,
                    dataSource: feedDataStrain,
                    xValueMapper: (PoultryData chick, _)=> chick.day,
                    yValueMapper: (PoultryData chick, _)=> chick.amount,

                  ),
                ],
              ),
            ),



          ],
        )
    );


  }
}

class PoultryData{
  final double amount;
  final int day;


  PoultryData(this.day,this.amount);
}

// Class for chart data source, this can be modified based on the data in Firestore
class ChartData {
  final double amount;
  final String day;

  ChartData(this.day,this.amount);



}
  