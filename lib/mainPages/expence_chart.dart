import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/hive/boxes.dart';
import 'package:money_manager/hive/model_class.dart';





class Mychart extends StatefulWidget {
  const Mychart({Key? key}) : super(key: key);

  @override
  _MychartState createState() => _MychartState();
}

class _MychartState extends State<Mychart> {
  late Box<transactions> box;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();
  double lengthofmonth(){
  DateTime now = DateTime.now();
  DateTime lastdayofmonth= DateTime( now.year, now.month+1, 0);
  return lastdayofmonth.day.toDouble();
  }

  int index = 1;

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  @override
  void initState() {
    super.initState();
   box= Boxes.gettransactions();
   
  }

  Future<List<transactions>> fetch() async{
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      // return Future.value(box.toMap());
      List<transactions>items=[];
      box.toMap().values.forEach((element) {
        items.add(transactions()
        ..transaction_amount=element.transaction_amount
        ..transaction_date=element.transaction_date
        ..isexpence=element.isexpence
        );
      });
      return items;
    }
  }

  List<FlSpot> getplotpoints(List<transactions> entiredata){
    dataSet = [];
    List<transactions> tempdataSet = [];
    for (transactions item in entiredata) {
      if (item.transaction_date.month==today.month && item.isexpence==true) {
        tempdataSet.add(item);
      }
    }
    // Sorting the list as per the date
    tempdataSet.sort((a, b) => a.transaction_date.day.compareTo(b.transaction_date.day),);
    for (var i = 0; i < tempdataSet.length; i++) {
      dataSet.add(
        FlSpot(
          tempdataSet[i].transaction_date.day.toDouble(), 
          tempdataSet[i].transaction_amount)
      );
    }
    return dataSet;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder<List<transactions>>(
              future: fetch(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
            return Center(
              child: Text(
                "Oopssss !!! There is some error !",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Not Enough Data to render Chart...!",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Add Two Or More Data Points to Render",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      "Chart",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    IconButton(onPressed: (){
                        setState(() {
                          getplotpoints(snapshot.data!);
                        });
                      }, icon:const Icon(Icons.refresh),iconSize: 30,)
                  ],
                ),
              );
            }
            getplotpoints(snapshot.data!);
            return ListView(
              padding: EdgeInsets.all(12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${months[today.month - 1]} ${today.year}',
                      style: const TextStyle(
                          fontSize: 32.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      IconButton(onPressed: (){
                        setState(() {
                          getplotpoints(snapshot.data!);
                        });
                      }, icon:const Icon(Icons.refresh),iconSize: 30,)
                  ],
                ),
                  dataSet.isEmpty || dataSet.length < 2 ?
                  Container(
                    padding: EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 20.0,
                        ),
                        margin: EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Text(
                          "Not Enough Data to render Chart",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                  )
                  : Container(
                    height: 600.0,
                        padding: EdgeInsets.symmetric(
                          vertical: 40.0,
                          horizontal: 12.0,
                        ),
                        margin: EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: LineChart(
                                  LineChartData(
                                    minX: 1,
                                    minY: 0,
                                    borderData: FlBorderData(
                                      show: true,
                                    ),
                                    gridData: FlGridData(),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: getplotpoints(snapshot.data!),
                                        isCurved: false,
                                        barWidth: 2.5,
                                        showingIndicators: [200, 200, 90, 10],
                                        dotData: FlDotData(
                                          show: true,
                                        ),
                                      )
                                    ]
                                  )
                                )
                  )
              ],
            );
          }
          throw{
            print('Njan moonji')
          };
              },)));
  }

  
}


