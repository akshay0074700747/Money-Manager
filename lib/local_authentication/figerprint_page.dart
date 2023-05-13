import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:money_manager/local_authentication/fingerprint_auth.dart';
import 'package:money_manager/main.dart';

class Fingerprintpage extends StatelessWidget {
  const Fingerprintpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Verify it's You"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(padding: EdgeInsets.all(20),
      child: Center(
        child: ElevatedButton.icon(onPressed: ()async{
          final isauthenticated=await LocalAuthApi.authenticate();
          if (isauthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return HomeNavigationPage(0);
            },));
          } 
        }, icon: Icon(Icons.lock), label: Text('Authenticate'))
      ),),
    );
  }
}