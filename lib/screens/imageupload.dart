import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutteraap/screens/app_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import http package manually

class ImageUpload extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ImageUpload();
  }
}

class _ImageUpload extends State<ImageUpload>{

  File uploadimage; //variable for choosed file

  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }

  Future<void> uploadImage() async {
    //show your own loading or progressing code here
var _token;
    String uploadurl = await AppUrl.uploadUserImages;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _token = (prefs.getString('access_token')??'');
    try{
      List<int> imageBytes = uploadimage.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      //convert file image to Base64 encoding
      var response = await http.post(
          uploadurl,
          headers: {"Accept": "application/json",
            "Authorization": "Bearer "+_token,
          },
          body: {
            'image': baseimage,
          }
      );
      print(response);
      print("response done");
      print(response.statusCode);
      if(response.statusCode == 200){
        print('DONE BRO');
        print(response.body);
        var jsondata = json.decode(response.body); //decode json data
        print(jsondata);
        print("upper json data");
        print(jsondata['message']);

        Flushbar(
          title: 'Uploaded Complete',
          message: jsondata['message'].toString(),
          duration: Duration(seconds: 10),
        ).show(context);
      }else{
        print("Error during connection to server");
        Flushbar(
          title: 'Error during connection to server',
          message: "unable to upload image",
          duration: Duration(seconds: 10),
        ).show(context);
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    }catch(e){
      print("Error during converting to Base64");
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image to Server"),
        backgroundColor: Colors.blue,
      ),
      body:Container(
        height:300,
        alignment: Alignment.center,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center, //content alignment to center
          children: <Widget>[
            Container(  //show image here after choosing image
                child:uploadimage == null?
                Container(): //if uploadimage is null then show empty container
                Container(   //elese show image here
                    child: SizedBox(
                        height:150,
                        child:Image.file(uploadimage) //load image from file
                    )
                )
            ),

            Container(
              //show upload button after choosing image
                child:uploadimage == null?
                Container(): //if uploadimage is null then show empty container
                Container(   //elese show uplaod button
                    child:RaisedButton.icon(
                      onPressed: (){
                        uploadImage();
                        //start uploading image
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text("UPLOAD IMAGE"),
                      color: Colors.deepOrangeAccent,
                      colorBrightness: Brightness.dark,
                      //set brghtness to dark, because deepOrangeAccent is darker coler
                      //so that its text color is light
                    )
                )
            ),

            Container(
              child: RaisedButton.icon(
                onPressed: (){
                  chooseImage(); // call choose image function
                },
                icon:Icon(Icons.folder_open),
                label: Text("CHOOSE IMAGE"),
                color: Colors.deepOrangeAccent,
                colorBrightness: Brightness.dark,
              ),
            )
          ],),
      ),
    );
  }
}