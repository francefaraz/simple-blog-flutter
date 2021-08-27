

import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutteraap/domain/user.dart';
import 'package:flutteraap/providers/auth.dart';
import 'package:flutteraap/utility/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';
import 'package:flutteraap/utility/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_url.dart';


class ListOfUsers extends StatefulWidget {

  Future<User> getUserData () => UserPreferences().getUser();

  @override
  _ListOfUsersState createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
  List _data = new List();
  String _token='';
  int _counter = 0;
  Future<String> getData() async {
    print("entered in data");
    print(await _token);
    print("agam");
    print(AppUrl.userList);
    var response = await http.get(
        Uri.encodeFull(AppUrl.userList),
        headers: {"Accept": "application/json",
          "Authorization": "Bearer "+_token,
        });
    // print(await response);
    print("done");
    setState(() {
      print(response.body);
      // response.json();
      final data = json.decode(response.body);
      _data = data["data"]['data'];
    });
    print("instance");
    print(_data);
    return "success";
  }

  void getDataUser(Map<String, dynamic>  a) {
    print(a);
    String b="ballon on the door1";
    Navigator.of(context).pushReplacementNamed('/displaysingleuser', arguments: a);

  }
  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await setState(() {
      _token = (prefs.getString('access_token')??'');
    });
    print("help");
    print(_token);
    await     getData();

  }
  @override
  void didChangeDependencies() {
    // RouteSettings settings = ModalRoute.of(context)!.settings;
    // if (settings.arguments != null) {
    //   CustomObject obj = settings.arguments as CustomObject;
    // }
    print("hello");

    _loadValue();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();

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
        title: Text("Flutter Api Example"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          // File image;
          // var imagePicker= await ImagePicker.pickImage(source: ImageSource.gallery);
          // if(imagePicker!=null){
          //   print("image is ");
          //   print(imagePicker);
          //   setState((){
          //     image=imagePicker;
          //   });
          //   print("image is ");
          //   print(image);
          // }
          Navigator.pushNamed(context, "/imgupload");
        },
        child: const Icon(Icons.upload),
        backgroundColor: Colors.red,
      ),

    );
  }

  Widget getList() {
    if (_data == null || _data.length < 1) {
      return Container(
        child: Center(child: Text("Please wait ....")),
      );
    }
    return ListView.separated(
      itemCount: _data?.length,
      itemBuilder: (BuildContext context, int index) {

        return getListItem(index);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget getListItem(int i) {
    print(_data[0].runtimeType);
    if (_data == null || _data.length < 1) return null;
    if (i == 0) {
      return Container(
        margin: EdgeInsets.all(4),
        child: Center(
            child: Text("LIST OF USERS",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ))),
      );
    }
    return Container(
        margin: EdgeInsets.all(4.0),
          // padding: EdgeInsets.all(4),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
            Text(
              i.toString()+" "+_data[i]['name'].toString() +
                    "\n " +
                    _data[i]['email'].toString(),
                style: TextStyle(
                  fontSize: 18,
                )),
            longButtons("Get "+_data[i]['name']+"Data Full",()=>getDataUser(_data[i]))

          ],
              ),
        );
  }
}
