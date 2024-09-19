import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
class InscriptionPage extends StatelessWidget {
  late SharedPreferences  prefs ;
  TextEditingController txt_login = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Registration Page", style: TextStyle(color: Colors.white))), backgroundColor: Colors.black, toolbarHeight: 240),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: txt_login,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1),
                )
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.safety_check),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(onPressed: (){
              _onInscrire(context);
            }, child:
            Text("Registration",style: TextStyle(fontSize: 20, color: Colors.white),),
            style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50),backgroundColor: Colors.black),),
          ),
          TextButton(
              child: Text("I already have an account",
              style: TextStyle(fontSize: 22 , color: Colors.black)),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/auth');
    }
          ),
        ],
      )
    );

  }

  Future<void>_onInscrire(BuildContext context) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("connecte", true);
    if (!txt_login.text.isEmpty && !password.text.isEmpty){
      prefs.setString("login", txt_login.text);
      prefs.setString("password", password.text);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
    }
    const snackBar = SnackBar(content: Text('Id or password empty'),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}


