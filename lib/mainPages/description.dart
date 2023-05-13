import 'package:flutter/material.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:money_manager/mainPages/edittransactions.dart';

class transaction_description extends StatefulWidget {
  final String transaction_name;
  final String transaction_note;
  final double transaction_amount;
  final String transaction_date;
  final bool isexpence;
  const transaction_description({super.key, required this.transaction_name, required this.transaction_note, required this.transaction_amount, required this.transaction_date, required this.isexpence});
  @override
  State<transaction_description> createState() => _transaction_descriptionState();
}

class _transaction_descriptionState extends State<transaction_description> {
  @override
  Widget build(BuildContext context) {
    final String amount=widget.transaction_amount.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                Text('Transaction Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Transaction Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                    )),
                    SizedBox(width: 30,),
                    Text(widget.transaction_name)
                  ],
                ),
                SizedBox(height: 30,),
                Text('Transaction Note',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                      fontSize: 15
                ),),
                SizedBox(height: 15,),
                Text(widget.transaction_note),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Transaction Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                    ),),
                    SizedBox(width: 30,),
                    Text(amount)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Transaction Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                    ),),
                    SizedBox(width: 30,),
                    Text(widget.transaction_date)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Transaction Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                    ),),
                    SizedBox(width: 30,),
                    Text(widget.isexpence ? 'Expence' : 'Income')
                  ],
                )
                ],
              ),
              ),
          )
        ],
      ),
    );
  }
}



