// ignore_for_file: prefer_const_constructors, file_names


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:money_manager/cloud_firestore/account_setup.dart';
import 'package:money_manager/cloud_firestore/cloud_storage_bucket.dart';
import 'package:money_manager/mainPages/faqpage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';



//actually these lines of code doesnt matter in this project its just used to fill the required field in valuenotifier
//No matter what this code does the value of image will be always initialized as null probably this function doest work, thats why the image is always initialized as null
Future<File> urlToFile(String imageUrl) async {
// generate random number.
var rng = new Random();
// get temporary directory of device.
Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in 
// temporary directory and image bytes from response is written to // that file.
return file;
}

//this one too....
 imagetofile(){
  urlToFile('https://media.istockphoto.com/id/1209654046/vector/user-avatar-profile-icon-black-vector-illustration.jpg?s=612x612&w=0&k=20&c=EOYXACjtZmZQ5IsZ0UUp1iNmZ9q2xl1BD1VvN6tZ2UI=');
 }
 
File? newpic;
 late int Age;
 late String emailAddress;

class account_settings extends StatefulWidget {
  const account_settings({super.key});

  @override
  State<account_settings> createState() => _account_settingsState();
}

class _account_settingsState extends State<account_settings> {
  @override
  void initState() {
    super.initState();
    userpref();
    downpref();
  }
 TextEditingController namecontrollerr=TextEditingController();

  TextEditingController agecontroller=TextEditingController();


  
  
  Future image_selector() async {
   final picked_image = await ImagePicker().pickImage(source: ImageSource.gallery);
   if (picked_image==null) {
     return;
   }else{
    final image_path= File(picked_image.path);
    setState(() {
      newpic=image_path;
    });
    profilepic.value=newpic;
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
                Text('Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(
                  height: 30,
                ),
                ValueListenableBuilder(
                  valueListenable: profilepic,
                  builder: ((context,File? img, child) {
                    return GestureDetector(
                    onTap: (() {
                     image_selector();
                    }),
                    child:  StreamBuilder<Account?>(
                          stream: readaccount(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final account=snapshot.data!;
                              return CircleAvatar(
                                    radius: 100,
                                    backgroundImage: 
                                    newpic==null ?
                                     account.imageurl.isNotEmpty ?
                                      NetworkImage(account.imageurl)
                                      : AssetImage('assets/y3ky12uavvr51.jpg') as ImageProvider
                                      :FileImage(newpic!)
                                  );
                            } else {
                              return CircleAvatar(
                                  radius: 100,
                                  backgroundImage: 
                                   profilepic.value != null ?
                                    FileImage(
                                      img!
                                    )
                                    : AssetImage('assets/y3ky12uavvr51.jpg') as ImageProvider,
                                    
                                );
                            }
                          },)
                  );
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: namecontrollerr,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder()
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
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(onPressed: () async{
                  Age=int.parse(agecontroller.text);
                  print(downloadurl);
                  await Storage().updateimage(downloadurl.getString('downloadurl')!, newpic!);
                  updateaccount( 
                    imageurl: downloadurl.getString('downloadurl')!,
                    name: namecontrollerr.text, 
                    age: Age); 
                    setState(() {
                      namecontroller=namecontrollerr;
                    }); 
                  Navigator.of(context).pop();
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
