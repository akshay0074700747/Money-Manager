import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/mainPages/transactionsPage.dart';
import 'package:money_manager/notifications/notification_api.dart';


final transaction_namecontoller=TextEditingController();
final transaction_notecontroller=TextEditingController();
final transaction_amountcontroller=TextEditingController();
DateTime date=DateTime.now();
Future transaction_popup(BuildContext context)async{
  return showDialog(context: context, builder: (newcontext) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
      alignment: Alignment.topCenter,
        child: SimpleDialog(
          title: Text('ADD TRANSACTION',style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),),
          children: [
            TextFormField(
              controller: transaction_namecontoller,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Transaction name'
              ),
            ),
            TextFormField(
              controller: transaction_notecontroller,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Transaction note'
              ),
            ),
            TextFormField(
              controller: transaction_amountcontroller,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Transaction amount'
              ),
            ),
              IconButton(
                onPressed: (){
                  showDatePicker(
                    context: context,
                initialDate: DateTime.now(), 
                firstDate: DateTime(2000,01,01), 
                lastDate: DateTime.now(),
                currentDate: DateTime.now(),).then((value) {
                  date=value!;
                });
                },
                icon: Icon(Icons.calendar_view_month_outlined),
              ),
            Row(
              children: [
                radiobutton('expence', true),
                SizedBox(width: 30,),
                radiobutton('income', false)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(newcontext);
                  }, 
                  child: Text('Cancel')),
                  TextButton(
                    onPressed: (){
                      addtransaction(
                        transaction_namecontoller.text, 
                        transaction_notecontroller.text, 
                        double.parse(transaction_amountcontroller.text), 
                        date, 
                        typenotifier.value);
                        Navigator.pop(newcontext);
                    }, 
                    child: Text('Add'))
              ],
            )
          ],
        ),
      ),
    );
  },);
}

ValueNotifier<bool> typenotifier=ValueNotifier(true);
Widget radiobutton(String title,bool transaction_type){
  return ValueListenableBuilder(
    valueListenable: typenotifier,
    builder: (context, newvalue, child) {
      return Row(
        children: [
          Radio<bool>(
            value: transaction_type, 
            groupValue: typenotifier.value, 
            onChanged: (value) {
              typenotifier.value=value!;
              typenotifier.notifyListeners();
            },),
            Text(title)
        ],
      );
    },);
}