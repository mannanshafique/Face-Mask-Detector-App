import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class FaceDetectionFromImage extends StatefulWidget {
  @override
  _FaceDetectionFromImageState createState() => _FaceDetectionFromImageState();
}

class _FaceDetectionFromImageState extends State<FaceDetectionFromImage> {
  File _image;
  int _imageWidth;
  int _imageHeight;
  bool _loading = false;
  List _recognitions;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/ml_trained_model/model_unquant.tflite",
      labels: "assets/ml_trained_model/labels.txt",
    );
  }

  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _loading = true;
      _image = image;
    });
    predictImage(image);
  }

  predictImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 0.0,
      imageStd: 127.5,
    );

    FileImage(image).resolve(ImageConfiguration()).addListener(
          (ImageStreamListener(
            (ImageInfo info, bool _) {
              setState(
                () {
                  _imageWidth = info.image.width;
                  _imageHeight = info.image.height;
                },
              );
            },
          )),
        );

    setState(() {
      _loading = false;
      _recognitions = recognitions;
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
            title: const Text('Face Mask Detector'),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Click To Select Image ! ',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                child: Icon(Icons.image),
                tooltip: "Pick Image from gallery",
                onPressed: selectFromImagePicker,
              ),
            ],
          ),
          body: _loading
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _image == null
                          ? Container(
                              child: Text(
                                "No image has been selected",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.file(
                                _image,
                                height: 300,
                                width: 300,
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      _recognitions != null
                          ? Stack(
                              children: <Widget>[
                                Text(
                                  "${_recognitions[0]["label"]}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25.0,
                                  ),
                                ),
                                Container(
                                  width: 16,
                                  color: Colors.blue,
                                  child: Text("He"),
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
                ),
        )
      ],
    );
  }
}
