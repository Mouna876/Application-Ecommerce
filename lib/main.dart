import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';
import 'home.dart';
import 'inscription.dart';
void main()  =>runApp(MyApp());
final routes ={
  '/home':(context)=> HomePage(),
  '/insc': (context) =>InscriptionPage(),
  '/auth':(context) => AuthPage(),

};
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        iconTheme: IconThemeData(color:Colors.black),
      ),
      home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context,snapshot)
          {
            if(snapshot.hasData){
              bool conn = snapshot.data?.getBool('connecte') ?? false;
              if(conn)
                return HomePage();
            }
            return AuthPage();
          }
      ),

    );
  }
}
