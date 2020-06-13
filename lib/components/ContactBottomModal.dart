import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:sari_sales/components/TakePhoto.dart';
import 'package:camera/camera.dart';

class ContactBottomModal extends StatefulWidget {

  @override
  createState () => _ContactBottomModal();
}

class _ContactBottomModal extends State<ContactBottomModal> {
  String _imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: getColorFromHex('#f3f3f3'),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Contact Form',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Name:'),
                          Container(
                            margin: EdgeInsets.only(right: 0, left: 0),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: TextField(
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
                                  hintText: 'Enter Name',
                                ),
                              )
                            ),
                          ),
                          Text('Contact:'),
                          Container(
                            margin: EdgeInsets.only(right: 0, left: 0),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: false,
                                  signed: false,
                                ),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
                                  hintText: 'Enter Phone',
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          WidgetsFlutterBinding.ensureInitialized();

                          // Obtain a list of the available cameras on the device.
                          final cameras = await availableCameras();

                          // Get a specific camera from the list of available cameras.
                          final firstCamera = cameras.first;
                          Navigator.push(context, PageRouteBuilder(
                            transitionDuration: Duration(seconds: 1),
                            pageBuilder: (context, a1, a2) => TakePhoto(camera: firstCamera, isCapture: (path, pictureId) {
                              setState(() {
                                _imagePath = path;
                              });
                              Navigator.pop(context);
                            }),

                          ));
                        },
                        child: Card(
                          elevation: 5,
                          child: _imagePath == null ? Hero(tag: 'takePhoto',child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.camera_front, size: 35, color: Colors.grey[500]),
                                Text('Add Picture', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))
                              ],
                            )
                          )) : Hero(
                            tag: 'takePhoto',
                            child: Image.file(
                              File(_imagePath),
                              fit: BoxFit.fill,
                            )
                          )
                        )
                      )
                    )
                  )
                ],
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('What Product do they supply?'),
                  Container(
                    margin: EdgeInsets.only(right: 0, left: 0),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: TextField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
                          hintText: 'Enter Product',
                        ),
                      )
                    ),
                  ),
                ],
              )
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
