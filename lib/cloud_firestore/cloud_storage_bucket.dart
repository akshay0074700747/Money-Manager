import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_manager/cloud_firestore/account_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences downloadurl;
Future<void>downpref()async{
downloadurl=await SharedPreferences.getInstance();
}
class Storage {
  final FirebaseStorage imagetostore=FirebaseStorage.instance;

  Future<void>uploadimage(File profile)async{
    final path='Accounts/${usernamecontroller.text}';
    final ref=FirebaseStorage.instance.ref().child(path);
    TaskSnapshot uploadedfile=await ref.putFile(profile);
    if (uploadedfile.state==TaskState.success) {
       downloadurl.setString('downloadurl', await ref.getDownloadURL());
    }
  }
  Future<void>updateimage(String imageurl,File newprofile)async{
    Reference imagetoupdate=FirebaseStorage.instance.refFromURL(imageurl);
    TaskSnapshot updatedfile= await imagetoupdate.putFile(newprofile);
    if (updatedfile.state==TaskState.success) {
      downloadurl.setString('downloadurl', await imagetoupdate.getDownloadURL());
    }
  }
}