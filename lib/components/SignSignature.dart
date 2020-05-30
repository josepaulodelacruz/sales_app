import 'dart:ui';
import 'dart:io';
  import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sari_sales/utils/colorParser.dart';
import 'package:signature/signature.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart';

class SignSignature extends StatefulWidget {
  String id;
  Function submitSignature;

  SignSignature({Key key, this.submitSignature, this.id }) : super(key: key);

  @override
  _SignSignature createState() => _SignSignature();
}

class _SignSignature extends State<SignSignature> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
//    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() => _controller.clear());
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              if (_controller.isNotEmpty) {
                var uuid = Uuid();
                String pictureId = uuid.v4();
                var data = await _controller.toPngBytes();
                final path = join( (await getTemporaryDirectory()).path, '${pictureId}.png', );
                File(path).writeAsBytesSync(data);
                print(path);
                widget.submitSignature(path);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Container(
        child: Signature(
          backgroundColor: getColorFromHex('#f3f3f3'),
          controller: _controller,
          height: MediaQuery.of(context).size.height,
        ),
      )
    );
  }
}
