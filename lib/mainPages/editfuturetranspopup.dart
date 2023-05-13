import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/hive/model_class.dart';
import 'package:money_manager/mainPages/upcomingTransactionsPage.dart';


final futuretrans_namecontoller=TextEditingController();
final futuretrans_notecontroller=TextEditingController();
final futuretrans_amountcontroller=TextEditingController();
DateTime editpickeddate=DateTime.now();
TimeOfDay editpickedtime=TimeOfDay.now();


Future editfuturetranspopup(BuildContext context,futuretransactions futuretransactions) async{
  return showDialog(context: context, builder: (newcontext) {
    return  Padding(padding: EdgeInsets.all(10),
    child: Align(
      alignment: Alignment.topCenter,
      child: SimpleDialog(
        title: Text('EDIT TRANSACTION',style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),),
          children: [
            TextFormField(
              controller: futuretrans_namecontoller,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Transaction name'
              )
            ),
            TextFormField(
              controller: futuretrans_notecontroller,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Transaction note'
              )
            ),
            TextFormField(
              controller: futuretrans_amountcontroller,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Transaction amount'
              )
            ),
            IconButton(onPressed: (){
               showDatePicker(
                context: context, 
                initialDate: DateTime.now(), 
                firstDate: DateTime.now(), 
                lastDate: DateTime(2100,01,01),
                currentDate: DateTime.now()).then((value) {
                  editpickeddate=value!;
                });
            }, icon: Icon(Icons.calendar_month)),
            IconButton(onPressed: (){
              showTimePicker(context: context,
               initialTime: TimeOfDay.now()).then((value) {
                editpickedtime=value!;
               });
            }, icon: Icon(Icons.more_time)),
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
                TextButton(onPressed: (){
                  Navigator.pop(newcontext);
                }, child: Text('Cancel')),
                TextButton(onPressed: (){
                  DateTime date=DateTime(
                    editpickeddate.year,
                    editpickeddate.month,
                    editpickeddate.day,
                    editpickedtime.hour,
                    editpickedtime.minute
                  );
                  editfuturetrans(
                    futuretransactions, 
                    futuretrans_namecontoller.text, 
                    futuretrans_notecontroller.text, 
                    double.parse(futuretrans_amountcontroller.text), 
                    date, 
                    typenotifier.value);
                    Navigator.pop(newcontext);
                }, child: Text('EDIT'))
              ],
            )
          ],
      ),
    ),);
  },);
}

ValueNotifier<bool> typenotifier=ValueNotifier(true);
Widget radiobutton(String name,bool transaction_type){
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
          Text(name)
      ],
    );
    },
  );
}