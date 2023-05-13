// ignore_for_file: file_names, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/cloud_firestore/account_setup.dart';
import 'package:money_manager/hive/boxes.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:money_manager/mainPages/description.dart';
import 'package:money_manager/mainPages/edittransactions.dart';
import 'package:money_manager/mainPages/transaction_popup.dart';

import '../hive/model_class.dart';

class PastTransactionsPage extends StatefulWidget {
  const PastTransactionsPage({Key? key}) : super(key: key);

  @override
  State<PastTransactionsPage> createState() => _PastTransactionsPageState();
}

class _PastTransactionsPageState extends State<PastTransactionsPage> {

  @override
  void dispose() {
    Hive.box('transactions').close();
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        // ignore: prefer_const_constructors
        title: Text(
          "Past Transactions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: IconButton(onPressed: ()async{
          return transaction_popup(context);
          
      }, icon: Icon(Icons.add)),
      body: (Container(child: UpcomingTransactionsList())),
    );
  }
}

class UpcomingTransactionsList extends StatefulWidget {
  const UpcomingTransactionsList();

  @override
  State<UpcomingTransactionsList> createState() =>
      _UpcomingTransactionsListState();
}

class _UpcomingTransactionsListState extends State<UpcomingTransactionsList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<transactions>>(
      valueListenable: Boxes.gettransactions().listenable(), 
      builder: (context, box, child) {
        final trans= box.values.toList().cast<transactions>();
        return buildcontent(trans);
      },);
  }
}

Future addtransaction(String name,String note,double amount,DateTime t_date,bool isitexpence) async{
final transactionobject=transactions()
..transaction_name=name
..transaction_note=note
..transaction_amount=amount
..transaction_date=t_date
..isexpence=isitexpence;

final box=Boxes.gettransactions();
box.add(transactionobject);
}

void edittransaction(
transactions transaction,
String name,
String note,
double amont,
DateTime trdate,
bool isitexpence
)
{
transaction.transaction_name=name;
transaction.transaction_note=note;
transaction.transaction_amount=amont;
transaction.transaction_date=trdate;
transaction.isexpence=isitexpence;

transaction.save();
}

void deletetransactions(transactions transaction){
  transaction.delete();
}


Widget buildcontent(List<transactions>trans){
  final netexpence=trans.fold<double>(
    0, 
    (previousValue, transaction) => transaction.isexpence ?
    previousValue - transaction.transaction_amount :
    previousValue + transaction.transaction_amount);
  return trans.isEmpty ? 
   Center(
    child: Text('No transactions yet !',
    style: TextStyle(
      fontSize: 20,
      color: Colors.grey,
      fontWeight: FontWeight.bold
    ),),
   ):
   Column(
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
          final transactionindex=trans[index];
          final datetrans=transactionindex.transaction_date;
          final formatteddate="${datetrans.day}-${datetrans.month}-${datetrans.year}";
          final amount=transactionindex.transaction_amount.toString();
           return GestureDetector(
            onDoubleTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return transaction_description(
                    transaction_name: transactionindex.transaction_name, 
                    transaction_note: transactionindex.transaction_note, 
                    transaction_amount: transactionindex.transaction_amount, 
                    transaction_date: formatteddate, 
                    isexpence: transactionindex.isexpence,);
                },));
            },
             child: Card(
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                title: Text(transactionindex.transaction_name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),),
                subtitle: Text(transactionindex.transaction_note,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade700
                ),),
                leading: Text(formatteddate),
                trailing: Text(amount,
                style: TextStyle(
                  color: transactionindex.isexpence ? Colors.red : Colors.green
                ),),
                children: [
                  Row(
                    children: [
                      Expanded(child: IconButton(onPressed: (){
                        edittransaction_popup(context, transactionindex);
                      }, icon: Icon(Icons.edit))),
                      Expanded(child: IconButton(onPressed: (){
                        deletetransactions(transactionindex);
                      }, icon: Icon(Icons.delete)))
                    ],
                  )
                ],
              ),
                     ),
           );
         },
         ),
       ),
     ],
   );
}
