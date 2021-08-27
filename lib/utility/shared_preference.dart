

import 'package:flutteraap/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    prefs.setString('token_type',user.token_type);
    prefs.setInt('expires_in',user.expires_in);
    prefs.setString('access_token',user.access_token);
    prefs.setString('refresh_token',user.refresh_token);


    return prefs.commit();

  }

  Future<User> getUser ()  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    String token_type = prefs.getString("token_type");
    int expires_in = prefs.getInt("expires_in");
    String access_token = prefs.getString("access_token");
    String refresh_token = prefs.getString("refresh_token");

    return User(

        token_type: token_type,
        expires_in: expires_in,
        access_token: access_token,
        refresh_token: refresh_token,
        );

  }

  void removeUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('token_type');
    prefs.remove('expires_in');
    prefs.remove('access_token');
    prefs.remove('refresh_token');


  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token_type");
    return token;
  }

}