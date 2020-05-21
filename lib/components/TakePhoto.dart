import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:uuid/uuid.dart';

import '../utils/colorParser.dart';

class TakePhoto extends StatefulWidget {
  final CameraDescription camera;
  final Function isCapture;

  TakePhoto({Key key, this.camera, this.isCapture }) : super(key: key);

  @override
  createState () => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  List<Color> _colors = [getColorFromHex('#5433FF '), getColorFromHex('#20BDFF')];

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: getColorFromHex('#20BDFF'),
      ),
      body: Hero(
          tag: 'takePhoto',
          child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var uuid = Uuid();
          String pictureId = uuid.v4();
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${pictureId}.png',
            );
            await _controller.takePicture(path);
            widget.isCapture(path, pictureId);
          } catch (e) {
            print(e);
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: _colors
            ),
          ),
          child: Icon(Icons.camera),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

