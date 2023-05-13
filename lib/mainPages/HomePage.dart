// ignore_for_file: prefer_const_constructors, file_names, unnecessary_import, unused_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers, avoid_print, must_be_immutable

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/authentication/authservice.dart';
import 'package:money_manager/cloud_firestore/account_setup.dart';
import 'package:money_manager/cloud_firestore/cloud_storage_bucket.dart';
import 'package:money_manager/hive/boxes.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:money_manager/mainPages/AccountPage.dart';
import 'package:money_manager/mainPages/description.dart';
import 'package:money_manager/mainPages/expence_chart.dart';
import 'package:money_manager/mainPages/faqpage.dart';
import 'package:money_manager/mainPages/transactionsPage.dart';
import 'package:money_manager/mainPages/upcomingTransactionsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


 ValueNotifier<bool> isnightmode=ValueNotifier(false);
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences preferances;
  @override
  void initState() {

    super.initState();
    
    init();
    userpref();
    downpref();
  }
  Future init()async{
    
    preferances=await SharedPreferences.getInstance();
    setState(() {
        
        if(preferances.getBool('bool')==null){
         isnightmode.value=false;
        }else{
isnightmode.value=preferances.getBool('bool')!;
        }
    });
     
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(onPressed: () async{
                          setState(() {
                          isnightmode.value ?
                          isnightmode.value=false :
                          isnightmode.value=true;
                          preferances.setBool('bool', isnightmode.value);
                          });
                          print(isnightmode);
                          
                        }, icon: isnightmode.value ? Icon(Icons.nightlight) : Icon(Icons.sunny)),
        )
      ],),
      drawer: Navigationdrawer(),
        body: Stack(children: [
      ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/background.png'))),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 20, top: 15),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        StreamBuilder(
                          stream: readaccount(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final account=snapshot.data!;
                              return Text(
                            "${account.profilename}...",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold
                            ),
                          );
                            }else{
                             return Text('Hey ${namecontroller.text}',
                             textAlign: TextAlign.left,
                   style: TextStyle(
                    fontWeight: FontWeight.bold,
                        fontSize: 26
                   ),);
                            }
                            
                          },
                        ),
                        Text(
                          "Expensive Day huh...!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 85,)
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Past Transactions",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => PastTransactionsPage())));
                      },
                      child: Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    )
                    ),
                
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
              height: 120,
              child: ValueListenableBuilder<Box<transactions>>(
                valueListenable: Boxes.gettransactions().listenable(),
                builder: (context, value, child) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Boxes.gettransactions().length,
                    itemBuilder: (context, int index) {
                      final trans=Boxes.gettransactions().values.toList().cast<transactions>();
                      final datetrans=trans[index].transaction_date;
                      final formatteddate="${datetrans.day}-${datetrans.month}-${datetrans.year}";
                      return trans.isEmpty ?
                      Text('No transactions yet') :
                      SizedBox(
                        height: 50,
                        width: 120,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return transaction_description(
                                  transaction_name: trans[index].transaction_name, 
                                  transaction_amount: trans[index].transaction_amount, 
                                  transaction_date: formatteddate, 
                                  transaction_note: trans[index].transaction_note, 
                                  isexpence: trans[index].isexpence,);
                              },)
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0.5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      trans[index].transaction_amount.toString(),
                                      style: TextStyle(
                                          color: trans[index].isexpence ? Colors.redAccent : Colors.greenAccent,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      trans[index].transaction_name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      "Before ${trans[index].transaction_date.difference(DateTime.now()).inDays.toString()} days",
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Plannings Ahead",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => TransactionPage())));
                      }),
                      child: Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    )
                    ),
                    
                  ],
                )
              ],
            ),
          ),
         VerticalList()
        ],
      ),
    ]));
  }
 }



class VerticalList extends StatefulWidget {
  const VerticalList({super.key});

  @override
  State<VerticalList> createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<futuretransactions>>(
      valueListenable: Boxes.getfuturetransactions().listenable(),
      builder: (context, value, child) {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 5),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: Boxes.getfuturetransactions().length,
          itemBuilder: (context, int index) {
            final trans=Boxes.getfuturetransactions().values.toList().cast<futuretransactions>();
            final transindex=trans[index];
            final t_date=transindex.transaction_date;
            final formatteddate="${t_date.day}-${t_date.month}-${t_date.year}";
            return trans.isEmpty ?
            Center(child: Text('No transactions yet'),) :
             SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return transaction_description(
                        transaction_name: transindex.transaction_name, 
                        isexpence: transindex.isexpence, 
                        transaction_amount: transindex.transaction_amount, 
                        transaction_date: formatteddate, 
                        transaction_note: transindex.transaction_note,);
                    },
                    ));
                },
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.greenAccent, width: 0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Text(
                    transindex.transaction_amount.toString(),
                    style: TextStyle(color: transindex.isexpence ? Colors.redAccent : Colors.greenAccent),
                  ),
                  title: Text(transindex.transaction_name),
                  trailing: Text(formatteddate),
                ),
              ),
            );
          });
      },
    );
  }
}

class Navigationdrawer extends StatefulWidget {
  const Navigationdrawer({super.key});

  @override
  State<Navigationdrawer> createState() => _NavigationdrawerState();
}

class _NavigationdrawerState extends State<Navigationdrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buidheader(context),
            buidmenuitems(context)
          ],
        ),
      ),
    );
  }

  Widget buidheader(BuildContext context){
    return Container(
      color: Colors.greenAccent,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top
      ),
      child: stream(context)
      );
  }

  Widget buidmenuitems(BuildContext context){
    return Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Account Settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => account_settings())));
          },
        ),
        ListTile(
          leading: Icon(Icons.question_answer),
          title: Text('FAQ'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
             builder: (context) {
              return faqfirestore();
                      },));
          },
        ),
        ListTile(
          leading: Icon(Icons.call),
          title: Text('Contact Us'),
          onTap: () async{
            Navigator.pop(context);
            await FlutterPhoneDirectCaller.callNumber('+917902611898');
          },
        ),
        ListTile(
          leading: Icon(Icons.bar_chart),
          title: Text('Expence Statistics'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Mychart();
            },));
          },
        ),
        Divider(color: Colors.black54,),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.pop(context);
            authservice().signout();
          },
        )
      ],
    );
  }

  Widget stream(BuildContext context){
    return StreamBuilder<Account?>(
      stream: readaccount(),
       builder: (context, snapshot) {
        if (snapshot.hasData) {
         final account=snapshot.data!;
          return Column(
            children: [
              CircleAvatar(
               minRadius: 60,
                backgroundImage: account.imageurl.isNotEmpty
                 ? NetworkImage(account.imageurl)
                  : AssetImage('assets/y3ky12uavvr51.jpg') as ImageProvider
                   ),
                   SizedBox(height: 15,),
                   Text('Hey ${account.profilename}',
                   style: TextStyle(
                    fontWeight: FontWeight.bold,
                        fontSize: 18
                   ),)
            ],
          );
                } else {
                 return Column(
            children: [
              ValueListenableBuilder(
                    valueListenable: profilepic,
                    builder: ((context,File? img, child) {
                      
                      return CircleAvatar(
                                radius: 100,
                                backgroundImage: 
                                 profilepic.value != null ?
                                  FileImage(
                                    img!
                                  )
                                  : AssetImage('assets/y3ky12uavvr51.jpg') as ImageProvider,
                                  
                              );
                    }),
                  ),
                   SizedBox(height: 15,),
                   Text('Hey ${namecontroller.text}',
                   style: TextStyle(
                    fontWeight: FontWeight.bold,
                        fontSize: 18
                   ),)
            ],
          );
                   }
                    },);
  }
}
