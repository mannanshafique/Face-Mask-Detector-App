import 'dart:async';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import './face_detection_camera.dart';
import './face_detection_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RoundedLoadingButtonController _btnController1 =
      new RoundedLoadingButtonController();

  final RoundedLoadingButtonController _btnController2 =
      new RoundedLoadingButtonController();

//Gallery
  void _doSomethingFromGallery() async {
    Timer(Duration(seconds: 1), () {
      _btnController1.success();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FaceDetectionFromImage(),
        ),
      );
      restController();
    });
  }

  void restController() {
    Timer(Duration(seconds: 1), () {
      _btnController1.reset();
      _btnController2.reset();
    });
  }

//LIve Camera
  void _doSomethingFromCamera() async {
    Timer(Duration(seconds: 3), () {
      _btnController2.success();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FaceDetectionFromLiveCamera(),
        ),
      );
      restController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/background.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: <Widget>[
              Padding(padding: EdgeInsets.all(9), child: Icon(Icons.search)),
            ],
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text('Face Mask Detector App'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Image.asset("images/maskIcon.png"),
                ),
                RoundedLoadingButton(
                  animateOnTap: true,
                  duration: Duration(seconds: 2),
                  elevation: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.image, color: Colors.white),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Detect face mask from the Image!',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  controller: _btnController1,
                  onPressed: _doSomethingFromGallery,
                ),
                SizedBox(
                  height: 20,
                ),
                RoundedLoadingButton(
                  animateOnTap: true,
                  duration: Duration(seconds: 2),
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Detect face mask from Live Camera!',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                  controller: _btnController2,
                  onPressed: _doSomethingFromCamera,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
