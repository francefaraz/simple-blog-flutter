import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutteraap/domain/user.dart';
import 'package:flutteraap/providers/auth.dart';
import 'package:flutteraap/providers/user_provider.dart';
import 'package:flutteraap/utility/validator.dart';
import 'package:flutteraap/utility/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final formKey=GlobalKey<FormState>();
   String _userName,_password;
//
// @override
// void didChangeDependencies() {
//   // RouteSettings settings = ModalRoute.of(context)!.settings;
//   // if (settings.arguments != null) {
//   //   CustomObject obj = settings.arguments as CustomObject;
//   // }
//   String s=ModalRoute.of(context).settings.arguments;
//   print("hello");
//   print(s);
//   super.didChangeDependencies();
// }
     @override
  Widget build(BuildContext context) {
       Auth auth=Provider.of<Auth>(context);
       var loading  = Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           CircularProgressIndicator(),
           Text(" Logging inn ... Please wait")
         ],
       );
       var dbLogin=(){
      // Navigator.pushReplacementNamed(context, '/listofusers');
final  form=formKey.currentState;
if(form.validate()){
  form.save();
  final Future<Map<String,dynamic>> response=auth.login(_userName,_password);

  print(response);
  response.then((resp){
    print("entered resp");

    print(resp['status']);
    if(resp['status']){
      print("hello far");
      print(resp['data']);

      User user=resp['data'];
      Provider.of<UserProvider>(context,listen: false).setUser(user);
      Navigator.pushReplacementNamed(context, '/listofusers');
    }
    else{
      Flushbar(
        title: 'Please Register Before Login',
        message: response.toString(),
        duration: Duration(seconds: 10),
      ).show(context);
    }
  });


}else{
  Flushbar(
    title: 'Invalid form',
    message: 'Please complete the form properly',
    duration: Duration(seconds: 10),
  ).show(context);
}
    // Navigator.of(context).pushReplacementNamed('/listofusers', arguments: 'Test String');
    };
  final forgotLabel = Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      FlatButton(
        padding: EdgeInsets.all(0.0),
        child: Text("Forgot password?",
            style: TextStyle(fontWeight: FontWeight.w300)),
        onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
        },
      ),
      FlatButton(
        padding: EdgeInsets.only(left: 0.0),
        child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/register');
        },
      ),
    ],
  );


  return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key:formKey,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                longButtons('Login',dbLogin),
                SizedBox(height: 8.0,),
                // FlatButton(
                //   padding: EdgeInsets.only(left: 0.0),
                //   child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
                //   onPressed: () {
                //     Navigator.pushReplacementNamed(context, '/register');
                //   },
                // ),
                SizedBox(height: 20.0,),
               auth.loggedInStatus == Status.Authenticating ? loading :
                longButtons('LIST OF USERS',dbLogin),          forgotLabel,



              ],
            )
          ),
        ),
      ),
    );
  }
}
