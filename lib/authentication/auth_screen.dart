import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/authentication/authservice.dart';
import 'package:money_manager/cloud_firestore/account_setup.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/mainPages/HomePage.dart';


final emailcontroller=TextEditingController();
class authentication_screen extends StatefulWidget {
  const authentication_screen({super.key});

  @override
  State<authentication_screen> createState() => _authentication_screenState();
}

class _authentication_screenState extends State<authentication_screen> {


  final Passcontroller=TextEditingController();
  final confirmpassctrl=TextEditingController();
  String? errormsg='';
  bool isloginpage=true;
  Future<void> createWithEmailAndPassword() async{
    try {
      authservice().createuser(
        email: emailcontroller.text, 
        password: Passcontroller.text);
    }on FirebaseAuthException catch (e) {
      setState(() {
        errormsg=e.message;
      });
    }
  }

  Future<void> signwithemailandpassword() async{
    try {
      authservice().signinuser(
        email: emailcontroller.text, 
        password: Passcontroller.text);
    }on FirebaseAuthException catch (e) {
      setState(() {
        errormsg=e.message;
      });
    }
  }

  Widget textfield(String title,TextEditingController controller){
    return TextFormField(
      controller: controller,
      keyboardType: title=='e-mail' ? TextInputType.emailAddress : TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
    );
  }

  Widget errormessage(){
    return Text(errormsg =='' ? '' : 'Humm ? $errormsg');
  }

  Widget submittbutton(){
    return ElevatedButton(
      onPressed: () async{
        if (Passcontroller.text==confirmpassctrl.text) {
          isloginpage ? signwithemailandpassword() : createWithEmailAndPassword();
         await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return accounts_setup();
            },));
            
        } else {
          final snackbar=SnackBar(
            content: Text("Passwords doesn't match "),
            duration: Duration(seconds: 5),
            elevation: 12,
            backgroundColor: Color.fromARGB(255, 255, 0, 64),);
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }, 
      child: Text(isloginpage ? 'Login' : 'register'));
  }

  Widget loginorregisterbutton(){
    return TextButton(
      onPressed: (){
        setState(() {
          isloginpage = !isloginpage;
        });
      }, 
      child: Text(isloginpage ? 'Register instead' : 'Login instead'));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Text(isloginpage ? 'Login Now !' : 'Register Now !',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              textfield('E-mail', emailcontroller),
              SizedBox(
                height: 25,
              ),
              textfield('Password', Passcontroller),
              SizedBox(
                height: 25,
              ),
              textfield('Confirm Password', confirmpassctrl),
              errormessage(),
              SizedBox(
                height: 25,
              ),
              submittbutton(),
              SizedBox(
                height: 25,
              ),
              loginorregisterbutton()
            ],
          ),
          ),
      ),
    );
  }
}