import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:sari_sales/components/SignSignature.dart';
import 'package:sari_sales/components/ViewLoans.dart';
import 'package:uuid/uuid.dart';
import 'package:sari_sales/utils/colorParser.dart';

//components
import '../../components/TakePhoto.dart';

//models
import '../../models/Loans.dart';

class LoanList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoanList();
  }
}

class _LoanList extends State<LoanList>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _address = TextEditingController();
  String _signature;
  String _imagePath;
  final _searchName = TextEditingController();
  List<dynamic> _personalLoans;
  List<dynamic> _searchLoans;
  Map<String, dynamic> _viewPerson;


  @override
  void initState () {
    _fetchLoansList();
    super.initState();
  }

  @override
  _fetchLoansList () async {
    await Loans.getLoanInformation().then((res) {
      setState(() {
        _personalLoans = res;
        _searchLoans = res;
      });
    });
  }

  @override
  void _resetState () {
    setState(() {
      _firstName.text = '';
      _lastName.text = '';
      _contactNumber.text = '';
      _address.text = '';
      _signature = null;
      _imagePath = null;
    });
  }

  @override
  void _handleSubmit () async {
    var uuid = Uuid();
    var id = uuid.v4();
    final _personalInformation = Loans(firstName: _firstName.text, lastName: _lastName.text, contactNumber: _contactNumber.text, personalAddress: _address.text, personalSignature: _signature, image: _imagePath, uid: id);
    final _isValid = await Loans.isValidate(_personalInformation);
    if(!_isValid) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.redAccent, content: new Text('Unable to Save')));
      return null;
    }
    await Loans.saveLoanInformation(_personalInformation.toJson()).then((res) {
      _resetState();
    }).then((res) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.green, content: new Text('Successfully added')));
    }).then((res) {
      _fetchLoansList();
    });
  }

  @override
  _handleView (viewUser) async {
    setState(() {
      _viewPerson = viewUser == 'Add' ? null : viewUser;
    });
  }

  @override
  _fuzzySearch (val) {
    setState(() {
      _personalLoans = val == '' ?
          _searchLoans?.map((loans) => loans)?.toList() ?? [] :
          _searchLoans.where((element) => element['first'].toString().toLowerCase().contains(val.toString().toLowerCase())).toList();
    });
  }


  @override
  Widget build(BuildContext context) {

    Widget _profileList = Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _personalLoans == null ? 1 : _personalLoans.length + 1,
        itemBuilder: (context, int index) {
          return index != 0 ? Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _handleView(_personalLoans[index - 1]);
                  },
                  child: CircleAvatar(
                    maxRadius: 36,
                    backgroundColor: Colors.grey[300],
                    child: Center(
                      child: ClipOval(
                          child: Image.file(
                            File(_personalLoans[index - 1]['imagePath']),
                            height: 60,
                            width: 60,
                            fit: BoxFit.fill,
                          )
                      ),
                    )
                  ),
                ),
                Text(_personalLoans[index - 1]['first'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
              ],
            )
          ) : Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _handleView('Add');
                    },
                    child: CircleAvatar(
                      maxRadius: 33,
                      backgroundColor: getColorFromHex('#f3f3f3'),
                      child: Icon(Icons.add, size: 32),
                    ),
                  ),
                  Text('Add')
                ],
              )
          );
        },
      )
    );

    Widget _formInputs = Container(
      padding: EdgeInsets.only(top: 70, right: 20, left: 20),
      child: ListView(
        children: <Widget>[
          Text('Personal Information.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black87)),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('First Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black87)),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Card(
                    child: TextField(
                      enabled: _viewPerson == null ? true : false,
                      controller: _firstName,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
                        hintText: _viewPerson == null ? 'Input First Name' : '${_viewPerson['first']}'),
                    )
                  ),
                ),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Last Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black87)),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Card(
                    child: TextField(
                      enabled: _viewPerson == null ? true : false,
                      controller: _lastName,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
                        hintText: _viewPerson == null ? 'Input Last Name' : '${_viewPerson['last']}'),
                    )
                  ),
                ),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Contact #', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black87)),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Card(
                    child: TextField(
                      enabled: _viewPerson == null ? true : false,
                      controller: _contactNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
                        hintText: _viewPerson == null ? 'Input Contact Number' : '${_viewPerson['contact']}'),
                    )
                  ),
                ),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black87)),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Card(
                    child: TextField(
                      enabled: _viewPerson == null ? true : false,
                      controller: _address,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.only(left: 15, bottom: 11, top: 15, right: 15),
                        hintText: _viewPerson == null ?  'Address' : '${_viewPerson['address']}'),
                    )
                  ),
                ),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Signature', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black87)),
                      _viewPerson == null ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _signature = null;
                          });
                        },
                      ) : SizedBox(),
                    ],
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  height: 150,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: InkWell(
                    onTap: () {
                      _viewPerson == null ? Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SignSignature(
                          submitSignature: (data) {
                            setState(() {
                              _signature = data;
                            });
                          },
                        ),
                      )) : null;
                    },
                    child: Hero(
                      tag: 'signature',
                      child: _viewPerson == null ? Card(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: _signature != null ? Image.file(File(_signature), fit: BoxFit.contain) : null,
                        )
                      ) : Card(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Image.file(File(_viewPerson['signature']), fit: BoxFit.contain)
                          )
                      ),
                    )
                  )
                ),
              ],
            )
          ),
        ],
      )
    );

    Widget _addPersonInformation = Expanded(
      flex: 1,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    getColorFromHex('##ECE9E6'),
                    getColorFromHex('#FFFFFF'),
                  ],
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: _formInputs,
            ),
            _viewPerson == null ? Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  WidgetsFlutterBinding.ensureInitialized();

                  // Obtain a list of the available cameras on the device.
                  final cameras = await availableCameras();

                  // Get a specific camera from the list of available cameras.
                  final firstCamera = cameras.first;
                  Navigator.push(context, PageRouteBuilder(
                    transitionDuration: Duration(seconds: 2),
                    pageBuilder: (context, a1, a2) => TakePhoto(camera: firstCamera, isCapture: (path, pictureId) {
                      setState(() {
                        _imagePath = path;
                      });
                      Navigator.pop(context);

                    }),
                  ));
                },
                child: _imagePath == null ? Hero(
                  tag: 'takePhoto',
                  child: CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Color.fromARGB(255, 148, 231, 225),
                    child: CircleAvatar(
                      maxRadius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.photo_camera)
                    ),
                  ),
                ) : Hero(
                  tag: 'takePhoto',
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Color.fromARGB(255, 148, 231, 225),
                    child: CircleAvatar(
                      radius: 45,
                      child: Center(
                        child: ClipOval(
                            child: Image.file(
                              File(_imagePath),
                              height: 90,
                              width: 90,
                              fit: BoxFit.fill,
                            )
                        ),
                      )
                    ),
                  )
                ),
              )
            ) : Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'viewLoan',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromARGB(255, 148, 231, 225),
                  child: CircleAvatar(
                    radius: 45,
                    child: Center(
                      child: ClipOval(
                        child: Image.file(
                          File(_viewPerson['imagePath']),
                          height: 90,
                          width: 90,
                          fit: BoxFit.fill,
                        )
                      ),
                    )
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, right: 35),
                child: _viewPerson == null ? IconButton(icon: Icon(Icons.check, color: Colors.green, size: 45), onPressed: () {
                  _handleSubmit();
                }) : IconButton(icon: Icon(Icons.add_shopping_cart, color: Colors.blueAccent), onPressed: () {
                  Navigator.push(context, PageRouteBuilder(
                    transitionDuration: Duration(seconds: 1),
                    pageBuilder: (context, a1, a2) => ViewLoans(
                      loanInfo: _viewPerson,
                    )
                  ));
                }),
              ),
            )
          ],
        )
      )
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: getColorFromHex('#20BDFF'),
        title: Text('Loan List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: _searchName,
              onChanged: (val) => _fuzzySearch(val),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _personalLoans = _searchLoans;
                      _searchName.text = '';
                    });
                  },
                )
              )
            )
          )
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _profileList,
            _addPersonInformation,
          ],
        ),
      )
    );
  }

}


