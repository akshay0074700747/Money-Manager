import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_manager/cloud_firestore/cloud_storage_bucket.dart';
import 'package:money_manager/local_authentication/figerprint_page.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/mainPages/AccountPage.dart';
import 'package:money_manager/mainPages/HomePage.dart';
import 'package:money_manager/mainPages/transaction_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';



class accounts_setup extends StatefulWidget {
  const accounts_setup({super.key});

  @override
  State<accounts_setup> createState() => _accounts_setupState();
}
TextEditingController namecontroller=TextEditingController();
ValueNotifier<File?>profilepic=ValueNotifier(imagetofile());
TextEditingController agecontroller=TextEditingController();
late SharedPreferences usernamepreference;
  TextEditingController usernamecontroller=TextEditingController();

Future<void> userpref()async{
    usernamepreference= await SharedPreferences.getInstance();
    
  }

class _accounts_setupState extends State<accounts_setup> {
  @override
  void initState() {
    
    super.initState();
    userpref();
    downpref();
  }
  


  Future image_picker() async{
    final picked_img=await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked_img==null) {
      return;
    } else {
      final img_path=File(picked_img.path);
      profilepic.value=img_path;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
         Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Text('Account Setup',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: (() {
                   image_picker();
                  }),
                  child: ValueListenableBuilder(
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
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)
                    )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)
                    )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: agecontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)
                    )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gender :'),
                  radiobutton('Male', true),
                  radiobutton('Female', false)
                ]),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(onPressed: () async{
                  await Storage().uploadimage(profilepic.value!);
                  await insertaccount( 
                    usrname: usernamecontroller.text, 
                    name: namecontroller.text, 
                    age: int.parse(agecontroller.text), 
                    gender: typenotifier.value,
                    imageurl: downloadurl.getString('downloadurl')!);
                    setState(() {
                      usernamepreference.setString('username', usernamecontroller.text);
                    });                    
                     Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return Fingerprintpage();
                      },));
                }, 
                child: Text('Save'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)
                ),
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

Future insertaccount({
  required String usrname,
  required String name,
  required int age,
  required bool gender,
  required String imageurl}) async{
    final doc_account=FirebaseFirestore.instance.collection('Accounts').doc(usrname);
    final acc=Account(
      username: usrname, 
      profilename: name, 
      age: age, 
      ismale: gender,
      imageurl: imageurl);
      final json=acc.tojson();
      await doc_account.set(json);
}

Stream<Account>readaccount() =>
FirebaseFirestore.instance.collection('Accounts').doc(usernamepreference.getString('username'))
.snapshots().map((snapshot) => Account.fromjson(snapshot.data()!)
);

Future updateaccount({required String name,required int age,required String imageurl}) async{
final update_account=FirebaseFirestore.instance.collection('Accounts').doc(usernamepreference.getString('username'));
update_account.update(
  {
    'name':name,
    'age':age,
    'imageurl':imageurl
  }
);
}

class Account{
  String username;
  String profilename;
  int age;
  bool ismale;
  String imageurl;

  Account({required this.username,required this.profilename,required this.age,required this.ismale,required this.imageurl});
  
  Map<String,dynamic> tojson() =>{
    'id':username,
    'name':profilename,
    'age':age,
    'gender':ismale,
    'imageurl':imageurl
  };

  static Account fromjson(Map<String,dynamic> json){
    return Account(
      username: json['id'], 
      profilename: json['name'], 
      age: json['age'], 
      ismale: json['gender'],
      imageurl: json['imageurl']);
  }
}
