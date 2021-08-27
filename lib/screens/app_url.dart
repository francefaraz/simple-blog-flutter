class AppUrl{

  //API BASE URL:
  static const String baseUrl='https://cupidknot.kuldip.dev/api';

  //1. Register User
  static const String register=baseUrl+"/register";
  //2. Login User
  static const String login=baseUrl+"/login";
  //3. Refresh API Auth Token
  static const String refreshToken=baseUrl+"/refresh";
  //4. Logout
  static const String logout=baseUrl+"/logout";
  //5. Own Profile
  static const String profile=baseUrl+"/user";
  //6. List of Users
  static const String userList=baseUrl+"/users";
  //7. Update User
  static const String updateUser=baseUrl+"/update_user";
  //8. Upload User Images
  static const String uploadUserImages=baseUrl+"/user_images";


}