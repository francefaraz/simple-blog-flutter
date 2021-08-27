class User {

  String token_type;
  int expires_in;
  String access_token;
  String refresh_token;


  User({this.token_type, this.access_token, this.expires_in, this.refresh_token});

  // now create converter

  factory User.fromJson(Map<String,dynamic> responseData){
    return User(

      token_type: responseData['token_type'],
      access_token : responseData['access_token'],
      expires_in: responseData['expires_in'],
      refresh_token : responseData['refresh_token']
    );
  }
}