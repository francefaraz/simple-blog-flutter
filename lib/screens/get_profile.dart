import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutteraap/providers/auth.dart';
import 'package:flutteraap/utility/validator.dart';
import 'package:flutteraap/utility/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetProfile extends StatefulWidget {


  @override
  _GetProfileState createState() => _GetProfileState();
}

class _GetProfileState extends State<GetProfile> {

   int d1=0;
  // {
  // "id": 45,
  // "name": "af fa",
  // "email": "afr4@gmail.com",
  // "email_verified_at": null,
  // "created_at": "2021-08-25T16:09:38.000000Z",
  // "updated_at": "2021-08-26T07:09:26.000000Z",
  // "first_name": "af",
  // "": "fa",
  // "religion": "muslim",
  // "": "1995-03-29",
  // "": "MALE",
  // "user_images": []
  // }

  _loadValue() async {
    Auth auth=Provider.of<Auth>(context);
    final Future<Map<String,dynamic>> response=  auth.getUserProfile();
    print(response);
    response.then((resp)async{
      print(resp['status']);
      if(resp['status']){

        var r=json.decode(resp['data'].toString());

       print(r);

        Navigator.of(context).pushReplacementNamed('/profile', arguments: r);

      }
      else{
        Flushbar(
          title: 'Profile Updated Unsuccessfull',
          message: 'Please Re-Login or check your internet connections',
          duration: Duration(seconds: 10),
        ).show(context);
      }
    });

  }
   @override
   void didChangeDependencies() {
     // RouteSettings settings = ModalRoute.of(context)!.settings;
     // if (settings.arguments != null) {
     //   CustomObject obj = settings.arguments as CustomObject;
     // }
     _loadValue();

     super.didChangeDependencies();
   }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(title: Text("Profile Update"),),
      body:Center(
      child:CircularProgressIndicator(),
      ),
    );
  }
}
