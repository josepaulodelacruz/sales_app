import 'package:flutter/material.dart';

import 'package:sari_sales/utils/colorParser.dart';
import 'package:sari_sales/models/Categories.dart';

class SettingScreen extends StatefulWidget {
  @override
  createState () => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  List _categories;

  @override
  void initState () {
    _fetchCategories();
    super.initState();
  }

  _fetchCategories () async {
    await Categories.getCategoryLocalStorage().then((res) {
      setState(() => _categories = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    List _textShadow = <Shadow>[
      Shadow(
        offset: Offset(10.0, 5.0),
        blurRadius: 8.0,
        color: Color.fromARGB(80, 0, 0, 255),
      ),
    ];

    // TODO: implement build
    return Scaffold(
      backgroundColor: getColorFromHex('#f3f3f3'),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                height: 80,
                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [
                      getColorFromHex('#00d2ff'),
                      getColorFromHex('#3a7bd5'),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ]
                ),
                child: Center(
                  child: Text('Settings', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white, shadows: _textShadow)),
                )
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.12,
                  right: 20,
                  left: 20,
                ),
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.only(top: 10, left: 15),
                              child: Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.grey)),
                            )
                          ),
                          ListTile(
                            title: Text('Sucription', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: FlatButton(
                              child: Text('Trial',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Expired at', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: FlatButton(
                                child: Text('Free',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Registered', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: FlatButton(
                                child: Text('Juan Dela Cruz',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.only(top: 10, left: 15),
                              child: Text('Product Storage', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.grey)),
                            )
                          ),
                          ExpansionTile(
                            title: Text('Categories', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            children: _categories?.map((cc) {
                              int index = _categories.indexOf(cc);
                              return index > 0 ? ListTile(
                                title: Text(cc['cTitle'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500])),
                                trailing: IconButton(icon: Icon(Icons.delete)),
                              ) : SizedBox();
                            })?.toList() ?? [],
                          ),
                          ListTile(
                            title: Text('Product Inventory', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: FlatButton(
                                child: Text('RESET',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Reports Inventory', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: FlatButton(
                                child: Text('RESET',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Categories', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: FlatButton(
                                child: Text('RESET',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Loan List', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: FlatButton(
                                child: Text('RESET',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.only(top: 10, left: 15),
                              child: Text('About', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.grey)),
                            )
                          ),
                          ListTile(
                            title: Text('Privacy Policy', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ),
                          ListTile(
                            title: Text('Terms and Condition', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ),
                          ListTile(
                              title: Text('About Application', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                              )
                          ),
                          ListTile(
                              title: Text('Report a problem', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                              )
                          ),
                          ListTile(
                              title: Text('Announcement', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                              )
                          ),
                        ]
                      ).toList(),
                    )
                  )
                )
              )
            ],
          )
        )
      )
    );
  }
}
