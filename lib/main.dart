import 'package:flutter/material.dart';
import 'package:flutteraap/providers/auth.dart';
import 'package:flutteraap/providers/user_provider.dart';
import 'package:flutteraap/screens/get_profile.dart';
import 'package:flutteraap/screens/imageupload.dart';
import 'package:flutteraap/screens/profile.dart';
import 'package:provider/provider.dart';
import 'domain/user.dart';
import 'screens/displaysingleuser.dart';
import 'screens/listofusers.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'package:flutteraap/utility/shared_preference.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<User> getUserData () => UserPreferences().getUser();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:
        [
      ChangeNotifierProvider(create: (_)=>Auth()),
          ChangeNotifierProvider(create: (_)=>UserProvider())
        ],
      child:MaterialApp(
        title: 'Login Registeration',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: getUserData(),
          builder: (context,snapshot){
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else if (snapshot.data.access_token == null)
                  return Login();
                else
                  Provider.of<UserProvider>(context).setUser(snapshot.data);
                return ListOfUsers();

            }
          },
        ),
        routes: {
          "/login":(context)=>Login(),
          "/register":(context)=>Register(),
          "/listofusers":(context)=>ListOfUsers(),
          "/displaysingleuser":(context)=>DisplaySingleUser(),
          "/getprofile":(context)=>GetProfile(),
          "/profile":(context)=>Profile(),
          "/imgupload":(context)=>ImageUpload()
        },
      )
    );


  }
}
