import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutteraap/domain/user.dart';
import 'package:flutteraap/screens/app_url.dart';
import 'package:flutteraap/utility/shared_preference.dart';
import 'package:flutteraap/utility/shared_preference.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';



enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}
enum Update{
  Yes,
  Processing,
  No
}

enum Image1{
  Success,
  Uploading,
  Failed

}

class Auth extends ChangeNotifier{

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Update _updateStatus=Update.No;
  Image1 _imageStatus=Image1.Failed;

  Image1 get imageStatus => _imageStatus;

  set imageStatus(Image1 value) {
    _imageStatus = value;
  }

  Update get updateStatus => _updateStatus;

  set updateStatus(Update value) {
    _updateStatus = value;
  }

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  Future<Map<String,dynamic>> register(String firstName,String lastName,String email,String password,String cPassword,String gender) async {
    final Map<String,dynamic> apiBody={
      'first_name':firstName,
      'last_name':lastName,
      'email':email,
      'password':password,
      'password_confirmation':cPassword,
      'gender':gender


    };
    _loggedInStatus = Status.Authenticating;
   print("apibody");
   print(apiBody);
   print(_loggedInStatus);
    return await post(AppUrl.register,
    body:json.encode(apiBody),
      headers:{'Content-Type':'application/json'}
    ).then(onValue)
    .catchError(onError);

  }
  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String,dynamic> responseData = json.decode(response.body);
    print(responseData);
    if(response.statusCode==200){
// var userData=responseData['date'];
    User authUser=User.fromJson(responseData);
    print(authUser);
    UserPreferences().saveUser(authUser);



    result = {
  'status':true,
  'message':'Successfully registered',
  'data':authUser
};

    }else{
      result = {
        'status':false,
        'message':'Successfully registered',
        'data':responseData
      };
    }
    return result;
  }


  Future<Map<String, dynamic>> login(String email, String password) async {

    var result;
    print("entereddddd");
    print(email);
    print(password);
    final Map<String, dynamic> loginData = {
      'username': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrl.login,
      body: json.encode(loginData),
      headers: {
        'Content-Type': 'application/json',
      //   'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
      //   'X-ApiKey' : 'ZGlzIzEyMw=='
      },
    );
    print("hellos");
    print(response.statusCode);

    if (response.statusCode == 200) {
        print(response.statusCode);
      final Map<String, dynamic> responseData = json.decode(response.body);

      print(responseData);

      var userData = responseData;
      print(responseData);

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};

    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;

  }



  Future<Map<String, dynamic>> logout() async {

    var _token,result;
    print("entereddddd");
    SharedPreferences prefs = await SharedPreferences.getInstance();

      _token = (prefs.getString('access_token')??'');

    print("help");
    print(_token);


    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrl.logout,

      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer "+_token

        //   'X-ApiKey' : 'ZGlzIzEyMw=='
      },
    );
    print("hellos");
    print(response.statusCode);

    if (response.statusCode == 200) {
       await prefs.clear();


       _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();

       result = {'status': true, 'message': 'Successful'};

    } else {
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;

  }



  Future<Map<String, dynamic>> getUserProfile() async {


    // _updateStatus=Update.No;
    // notifyListeners();
    var _token,result;

    print("entereddddd");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = (prefs.getString('access_token')??'');

    print("help");
    print(_token);




    Response response = await get(
      AppUrl.profile,

      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer "+_token

        //   'X-ApiKey' : 'ZGlzIzEyMw=='
      },
    );
    print("hellos");
    print(response.statusCode);

    if (response.statusCode == 200) {
      result = { "status":true,"data":response.body};

      // _updateStatus=Update.Yes;
      // notifyListeners();
      print('done updated');

    } else {
      _loggedInStatus = Status.LoggedOut;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;

  }


  Future<Map<String,dynamic>> updateProfile(String firstName,String lastName,String email,String religion,String birth,String gender) async {
    _updateStatus = Update.Processing;
    notifyListeners();


    var _token,result;

    print("entered in update profile");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = (prefs.getString('access_token')??'');

    print("help");
    print(_token);


    final Map<String,dynamic> apiBody={
      'first_name':firstName,
      'last_name':lastName,
      'email':email,
      'religion':religion,
      'birth_date':birth,
      'gender':gender


    };
    print("api body is");
    print(apiBody);
    Response response = await post(
      AppUrl.updateUser,
      body: json.encode(apiBody),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer "+_token

        //   'X-ApiKey' : 'ZGlzIzEyMw=='
      },
    );
    print("hello update method");
    print(response.statusCode);

    if (response.statusCode == 200){

      _updateStatus = Update.Yes;
      notifyListeners();
      result = { "status":true,"data":response.body};


    print('done updated');

  } else {

      _updateStatus = Update.No;
      notifyListeners();
  result = {
  'status': false,
  'message': json.decode(response.body)['error']
  };
  }

  return result;

    }



  Future<Map<String,dynamic>> uploadImage(var image) async {
    _imageStatus = Image1.Uploading;
    notifyListeners();


    var _token,result;

    print("entered in update profile");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = (prefs.getString('access_token')??'');

    print("help");
    print(_token);


    final Map<String,dynamic> apiBody={
      'orginal_image':image


    };
    print("api body is");
    print(apiBody);
    Response response = await post(
      AppUrl.uploadUserImages,
      body: json.encode(apiBody),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer "+_token

        //   'X-ApiKey' : 'ZGlzIzEyMw=='
      },
    );
    print("hello update method");
    print(response.statusCode);

    if (response.statusCode == 200){

      _imageStatus=Image1.Success;
      notifyListeners();
      result = { "status":true,"data":"uploaded Successfully :)"};


      print('done updated');

    } else {

      _imageStatus=Image1.Failed;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;

  }




  static onError(error){
    print('the error is ${error.detail}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }


}