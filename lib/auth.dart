import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatelessWidget {
  late SharedPreferences prefs;

  TextEditingController txt_login = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Login Page", style: TextStyle(color: Colors.white))), backgroundColor: Colors.black , toolbarHeight: 240,),
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
                  )),
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
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                _onauth(context);
              },
              child: Text(
                "Authenticate",
                style: TextStyle(fontSize: 20 , color: Colors.white ),
              ),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50), backgroundColor: Colors.black, textStyle: TextStyle( fontFamily: "Kanit" ,fontSize: 20)),
            ),
          ),
          TextButton(
              child: Text("New User", style: TextStyle(fontSize: 22 , color:Colors.black ),),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/insc');
              }),
        ],
      ),
    );
  }

  Future<void> _onauth(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("connecte", true);
    String log = prefs.getString("login") ?? '';
    String passw = prefs.getString("password") ?? '';
    if (txt_login.text == log && password.text == passw) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
    } else {
      const snackBar = SnackBar(
        content: Text('Verify your username and password'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
