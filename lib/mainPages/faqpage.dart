import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/authentication/auth_screen.dart';
import 'package:money_manager/cloud_firestore/account_setup.dart';
import 'package:money_manager/mainPages/AccountPage.dart';


class faqfirestore extends StatefulWidget {
  const faqfirestore({super.key});

  @override
  State<faqfirestore> createState() => _faqfirestoreState();
}

class _faqfirestoreState extends State<faqfirestore> {
  final msgcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
                        Text('Let us know how you feel !',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Feel free to talk to us...",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        ),),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 250,
                              height: 35,
                              child: TextFormField(
                              controller: msgcontroller,
                              maxLengthEnforcement: MaxLengthEnforcement.none,
                              decoration: InputDecoration(
                                labelText: 'Say Something',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                          ),
                            ),
                          IconButton(onPressed: (){
                            final message=msgcontroller.text;
                            sendmsg(message: message);
                          }, icon: Icon(Icons.send))
                          ]
                        ),
                        StreamBuilder<List<Message>>(
                          stream: readmessages(),
                          builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final messages=snapshot.data!;
                            final messagecount=messages.length;
                            return Expanded(
                              child: messagesdisplay(messagecount, messages)
                            );
                          }
                          else{
                            return Text('an unknown error occured');
                          }
                        },) 
            ],
          ),
        ),
      ),
    );
  }
}


Future sendmsg({required String message}) async{
String date=DateFormat().format(DateTime.now()).toString()+emailcontroller.text;
final docmsg=FirebaseFirestore.instance.collection('messages').doc(date);
final msg=Message(message: message,id: docmsg.id);
final json=msg.tojson();
await docmsg.set(json);
}
Stream<List<Message>>readmessages() =>
  FirebaseFirestore.instance
  .collection('messages')
  .snapshots()
  .map((snapshot) => 
  snapshot.docs.map((doc) =>Message.fromjson(doc.data())).toList());


   

  

  Widget messagesdisplay(int totalmsg, List<Message> msgs){
      return ListView.builder(
        itemCount: totalmsg,
        itemBuilder: (context, index) {
          return GestureDetector(
            onDoubleTap: () {
            deletemessage(msgs[index].id);  
            },
            child: SizedBox(
              height: 40,
              child: Text(msgs[index].message)));
        }, );
  }

  Future<void> deletemessage(String messageid) async{
FirebaseFirestore.instance.collection('messages').doc(messageid).delete();
  }

  class Message{
    String id;
    String message;

    Message({required this.id,required this.message});

    Map<String,dynamic>tojson() =>{
      'id':id,
      'msg':message
    };

   static Message fromjson(Map<String, dynamic> json){
    return Message(
      id: json['id'],
      message: json['msg']
      );
  }
  }

