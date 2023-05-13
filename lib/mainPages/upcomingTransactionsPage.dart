// ignore_for_file: file_names, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/hive/boxes.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:money_manager/mainPages/description.dart';
import 'package:money_manager/mainPages/editfuturetranspopup.dart';
import 'package:money_manager/mainPages/futuretransaction_popup.dart';
import 'package:money_manager/notifications/notification_api.dart';


class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}
NotificationService notificationServices = NotificationService();
class _TransactionPageState extends State<TransactionPage> {
  

  @override
  void dispose(){
    Hive.box('futuretransactions').close();
    super.dispose();
  }
@override
  void initState() {
    super.initState();
    notificationServices.init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text(
          "Upcoming Transactions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: IconButton(onPressed: ()async{
        return futuretrans_popup(context);
      }, icon: Icon(Icons.add)),
      body: (Container(child: const PastTransactionsList())),
    );
  }
}

class PastTransactionsList extends StatefulWidget {
  const PastTransactionsList();

  @override
  State<PastTransactionsList> createState() => _PastTransactionsListListState();
}

class _PastTransactionsListListState extends State<PastTransactionsList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Boxes.getfuturetransactions().listenable(), 
      builder: (context, box, child) {
        final trans=box.values.toList().cast<futuretransactions>();
        return buildcontent(trans);
      },);
}
}

Future addfuturetrans(String title,String note,double amount,DateTime t_date,bool isitexpence) async{
  final futuretransobject=futuretransactions()
  ..transaction_name=title
  ..transaction_note=note
  ..transaction_amount=amount
  ..transaction_date=t_date
  ..isexpence=isitexpence;
  Boxes.getfuturetransactions().add(futuretransobject);
  notificationServices.scheduleNotification(futuretransobject);
}

void editfuturetrans(
  futuretransactions futuretrans,
  String name,
  String note,
  double amount,
  DateTime t_date,
  bool isitexpence
){
  futuretrans.transaction_name=name;
  futuretrans.transaction_note=note;
  futuretrans.transaction_amount=amount;
  futuretrans.transaction_date=t_date;
  futuretrans.isexpence=isitexpence;
  futuretrans.save();
  notificationServices.scheduleNotification(futuretrans);
}



void deletefuturetrans(futuretransactions futuretrans){
  notificationServices.cancelNotification(futuretrans.key);
  futuretrans.delete();
}

Widget buildcontent(List<futuretransactions>trans){
  final netexpence=trans.fold<double>(
    0, 
    (previousValue, transaction) => transaction.isexpence ?
    previousValue-transaction.transaction_amount :
    previousValue+transaction.transaction_amount);
  return trans.isEmpty ?
  const Center(
    child: Text('No transactions yet !',
    style: TextStyle(
      fontSize: 20,
      color: Colors.grey,
      fontWeight: FontWeight.bold
    ),),
   ) : Column(
    children: [
     SizedBox(
        height: 25,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Net Transaction',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),),
          Text('$netexpence',
          style: TextStyle(
            color: netexpence.isNegative ? Colors.red : Colors.green
          ),)
        ],
      ),
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: trans.length,
          itemBuilder: (context, index) {
            final transindex=trans[index];
            final datetrans=transindex.transaction_date;
            final formatteddate="${datetrans.day}-${datetrans.month}-${datetrans.year}";
            return GestureDetector(
              onDoubleTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return transaction_description(
                      transaction_name: transindex.transaction_name, 
                      transaction_note: transindex.transaction_note, 
                      transaction_amount: transindex.transaction_amount, 
                      transaction_date: formatteddate, 
                      isexpence: transindex.isexpence,);
                  },));
              },
              child: Card(
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                title: Text(transindex.transaction_name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),),
                subtitle: Text(transindex.transaction_note,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade700
                ),),
                leading: Text(formatteddate),
                trailing: Text(transindex.transaction_amount.toString(),
                style: TextStyle(
                  color: transindex.isexpence ? Colors.red : Colors.green
                ),),
                children: [
                  Row(children: [
                  Expanded(child: IconButton(onPressed: (){
                    editfuturetranspopup(context, transindex);
                  }, icon: Icon(Icons.edit))),
                  Expanded(child: IconButton(onPressed: (){
                    deletefuturetrans(transindex);
                  }, icon: Icon(Icons.delete)))
                  ],)
                ],
              ),
                     ),
            );
          },))
    ],
   );
}