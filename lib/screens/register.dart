import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutteraap/domain/user.dart';

import 'package:flutteraap/providers/auth.dart';
import 'package:flutteraap/providers/user_provider.dart';
import 'package:flutteraap/utility/validator.dart';
import 'package:flutteraap/utility/widgets.dart';
import 'package:provider/provider.dart';



class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final formKey=GlobalKey<FormState>();

  String _userName,_password,_cpassword,_firstName,_lastName,gender='MALE';

  @override
  Widget build(BuildContext context) {

    Auth auth = Provider.of<Auth>(context);

    var loading  = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var doRegister=(){
     print("do register");
     final form = formKey.currentState;
     if(form.validate()){
        form.save();
        auth.loggedInStatus = Status.Authenticating;


        print("username"+_userName);
        print("password"+_password);
        print("confirm password"+_cpassword);
          if(_password.endsWith(_cpassword)){
                auth.register(_firstName,_lastName,_userName,_password,_cpassword,gender).then((response){
                  if(response['status']){
                    print("set logged in success");
                    User user=response['data'];
                    print("user ley");
                    print(user);
                    // Provider.of<UserProvider>(context).setUser(user);
                    auth.loggedInStatus = Status.LoggedIn;

                    Navigator.pushReplacementNamed(context, '/login');
                  }
                  else{
                    Flushbar(
                      title: 'Registration fail',
                      message: response.toString(),
                      duration: Duration(seconds: 10),
                    ).show(context);
                  }
                });
          }
          else{
            Flushbar(
              title: 'Password Mismatch',
              message: 'Please enter valid confirm password',
              duration: Duration(seconds: 10),
            ).show(context);
          }
     }
     else{
       Flushbar(
         title: 'Invalid form',
         message: 'Please complete the form properly',
         duration: Duration(seconds: 10),
       ).show(context);
     }
    };
    return Scaffold(
      appBar: AppBar(title: Text("Registration"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key:formKey,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Text("First Name"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    validator: (value)=>value.isEmpty?"Please Enter FirstName":null,
                    onSaved: (value)=> _firstName=value,
                    decoration: buildInputDecoration("Enter First Name",Icons.menu),
                  ),
                  SizedBox(height: 15.0,),
                  Text("First Name"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    validator: (value)=>value.isEmpty?"Please Enter LastName":null,
                    onSaved: (value)=> _lastName=value,
                    decoration: buildInputDecoration("Enter Last Name",Icons.menu),
                  ),
                  SizedBox(height: 15.0,),
                  Text("Email"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    validator: validateEmail,
                    onSaved: (value)=> _userName=value,
                    decoration: buildInputDecoration("Enter Email",Icons.email),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Password"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    validator: (value)=>value.isEmpty?"Please Enter Password":null,
                    onSaved: (value)=> _password=value,
                    decoration: buildInputDecoration("Enter Password",Icons.lock),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Confim Password"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    validator: (value)=>value.isEmpty?"Please Confirm your Password":null,
                    onSaved: (value)=> _cpassword=value,
                    decoration: buildInputDecoration("Enter Confirm Password",Icons.lock),
                  ),
                  SizedBox(height: 20.0,),
                  auth.loggedInStatus== Status.Authenticating ? loading  : longButtons('Register',doRegister),
                  SizedBox(height: 8.0,),
                  FlatButton(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text("Alredy Have Account then Sign In", style: TextStyle(fontWeight: FontWeight.w300)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),

                ],
              )
          ),
        ),
      ),
    );
  }
}
