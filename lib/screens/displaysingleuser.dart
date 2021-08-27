import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutteraap/providers/auth.dart';
import 'package:flutteraap/providers/user_provider.dart';
import 'package:flutteraap/utility/widgets.dart';
import 'package:provider/provider.dart';

class DisplaySingleUser extends StatefulWidget {

  @override
  _DisplaySingleUserState createState() => _DisplaySingleUserState();
}

class _DisplaySingleUserState extends State<DisplaySingleUser> {
  Map<String, dynamic>  a;
  // String a;
  @override
  void didChangeDependencies() {
    // RouteSettings settings = ModalRoute.of(context)!.settings;
    // if (settings.arguments != null) {
    //   CustomObject obj = settings.arguments as CustomObject;
    // }
    a=ModalRoute.of(context).settings.arguments;
    print("hello");
    print(a);
    print(a.runtimeType);
    super.didChangeDependencies();
  }
  void  onBack() {
    Navigator.pushReplacementNamed(context, '/listofusers');


  }

  @override
  Widget build(BuildContext context) {
    Auth auth=Provider.of<Auth>(context);
    void handleClick(String value) {
      switch (value) {
        case 'Logout':
          final Future<Map<String,dynamic>> response=auth.logout();
          response.then((resp){
            print("entered resp");

            print(resp['status']);
            if(resp['status']){
              print("hello far");
              print(resp['data']);



              Navigator.pushReplacementNamed(context, '/login');
            }
            else{
              Flushbar(
                title: 'Logout Unsuccessfull',
                message: response.toString(),
                duration: Duration(seconds: 10),
              ).show(context);
            }
          });

          break;
        case 'Settings':
          print("clicked on Setttings");
          Navigator.pushNamed(context, '/getprofile');

          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("USER DETAILS"),
        actions:<Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Settings','Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: getList(),
      ),
    );
  }

  Widget getList() {



    return Container(
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Column(children: <Widget>[
            Text("Name : "+a['name'].toString()+" "+"\ne mail : "+a['email'].toString()+"\nGender :"+a['gender'].toString()+"\nReligion "+a['religion'].toString()+"\nBirth  "+a['birth_date'].toString(),
                style: TextStyle(
                  fontSize: 18,
                )),
            // Image.network((a['picture']['medium'].toString()),
            //     width: 200, height: 200),
            longButtons("Back",onBack)
          ]),
        )
    );
  }



}
