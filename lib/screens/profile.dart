import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutteraap/providers/auth.dart';
import 'package:flutteraap/utility/validator.dart';
import 'package:flutteraap/utility/widgets.dart';
import 'package:provider/provider.dart';
class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
var a;
final formKey=GlobalKey<FormState>();

String _email,_religion,_birth,_firstName,_lastName,gender;

  @override
  void didChangeDependencies() {
    // RouteSettings settings = ModalRoute.of(context)!.settings;
    // if (settings.arguments != null) {
    //   CustomObject obj = settings.arguments as CustomObject;
    // }
    print("hello");
    a=ModalRoute.of(context).settings.arguments;
    print("hello");
    print(a);
    print(a.runtimeType);
    print('update status is ');

    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    Auth auth=Provider.of<Auth>(context);
    var loading  = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Updating ... Please wait")
      ],
    );

    var doUpdate=(){
      print("do update");
      print(auth.updateStatus);
      final form = formKey.currentState;
      if(form.validate()) {
        form.save();
        auth.updateStatus = Update.Processing;


        print("username" + _email);
        print("password" + _firstName);
        print("confirm password" + _lastName);

        final Future<Map<String, dynamic>> response = auth.updateProfile(
            _firstName, _lastName, _email, _religion, _birth, gender);

        print(response);
        response.then((resp) {
          print("entered resp");

          print(resp['status']);
          if (resp['status']) {
            print("hello far");
            print(resp['data']);

            auth.updateStatus = Update.Yes;
            Flushbar(
              title: 'Successfully',
              message: "Profile Updated",
              duration: Duration(seconds: 10),
            ).show(context);
          }
          // Navigator.pushReplacementNamed(context, '/listofusers');

          else {
            Flushbar(
              title: 'Profile Updated Unsuccessfull',
              message: 'Please Re-Login or check your internet connections',
              duration: Duration(seconds: 10),
            ).show(context);

            Navigator.pushReplacementNamed(context, '/login');

          }
        });
      }
    };

    return Scaffold(
      appBar: AppBar(title: Text("Profile Update"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child:  Form(
              key:formKey,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Text("First Name"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    initialValue: a['first_name'],
                    validator: (value)=>value.isEmpty?"FirstName Cannot Be Empty|":null,
                    onSaved: (value)=> _firstName=value,
                    decoration: buildInputDecoration("Enter First Name",Icons.perm_contact_calendar),
                  ),
                  SizedBox(height: 15.0,),
                  Text("Last Name"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    initialValue: a['last_name'],
                    validator: (value)=>value.isEmpty?"LastName Cannot Be Empty|":null,
                    onSaved: (value)=> _lastName=value,
                    decoration: buildInputDecoration("Enter Last Name",Icons.perm_contact_calendar_rounded),
                  ),
                  SizedBox(height: 15.0,),
                  Text("Email"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    initialValue: a['email'],
                    // validator: validateEmail,
                    readOnly: true,
                    onSaved: (value)=> _email=value,
                    decoration: buildInputDecoration("Enter Email",Icons.email),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Religon"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    initialValue: a['religion'],
                    // validator: (value)=>value.isEmpty?"Please Enter Password":null,
                    onSaved: (value)=> _religion=value,
                    decoration: buildInputDecoration("Enter Your Religion/Caste",Icons.mood),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Date Of Birth"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    initialValue: a['birth_date'],
                    // validator: (value)=>value.isEmpty?"Please Confirm your Password":null,
                    onSaved: (value)=> _birth=value,
                    decoration: buildInputDecoration("Enter DOB",Icons.calendar_today),
                  ),
                  SizedBox(height: 20.0,),

                  auth.updateStatus == Update.Processing ? loading: longButtons('Update Profile',doUpdate),
                  SizedBox(height: 8.0,),

                ],
              )
          ),
        ),
      ),
    );
  }
}
