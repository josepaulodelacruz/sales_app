import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sari_sales/components/AppDialog.dart';
import 'package:sari_sales/components/SettingConfirmationModal.dart';
import 'package:sari_sales/components/MarkdownReader.dart';
import 'package:sari_sales/models/Users.dart';

import 'package:sari_sales/utils/colorParser.dart';
import 'package:sari_sales/models/Categories.dart';
import 'package:sari_sales/models/ListProducts.dart';

class SettingScreen extends StatefulWidget {
  @override
  createState () => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  String _status;
  List _categories;

  @override
  void initState () {
    _fetchCategories();
    super.initState();
  }

  _fetchCategories () async {
    List<Future> futures = [
      Categories.getCategoryLocalStorage(),
      Users.userGetStatusPersistent()
    ];
    List results = await Future.wait(futures);
    setState(() {
      _categories = results[0];
      _status = results[1];
    });
  }

  @override
   _buildShowModal(BuildContext context, type) {
    return showDialog(
      context: context,
      builder: (context) {
        return SettingConfirmationModal(
          typeReset: type,
        );
      }
    );
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
                            title: Text('Subscription', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.card_membership),
                            trailing: FlatButton(
                              child: Text(_status == 'trial' ? 'Trial' : 'Premium',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Expired at', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.date_range),
                            trailing: FlatButton(
                                child: Text('Free',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Registered', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.home),
                            trailing: FlatButton(
                                child: Text('N/A',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
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
                            leading: Icon(Icons.list),
                            children: _categories?.map((cc) {
                              int index = _categories.indexOf(cc);
                              return index > 0 ? ListTile(
                                title: Text(cc['cTitle'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500])),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                       title: Text('Remove ${cc['cTitle']}'),
                                       content: Text(
                                         'Are you sure you want to delete this category? All products asscociated with this category shall be deleted.',
                                         style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w500),
                                       ),
                                       actions: <Widget>[
                                         FlatButton(
                                           onPressed: () => Navigator.pop(context),
                                           child: Text('No'),
                                         ),
                                         FlatButton(
                                           child: Text('Yes'),
                                           onPressed: () async {
                                             await Categories.deleteCategory(cc['cTitle'], index).then((res) {
                                               _fetchCategories();
                                               Navigator.of(context).pop();
                                             });
                                           },
                                         ),
                                       ],
                                      )
                                    );
                                  },
                                ),
                              ) : SizedBox();
                            })?.toList() ?? [],
                          ),
                          ListTile(
                            title: Text('Product Inventory', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.shopping_basket),
                            trailing: FlatButton(
                              onPressed: () async {
                                _buildShowModal(context, 'ProductReset');
                              },
                              child: Text('RESET',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Reports', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.table_chart),
                            trailing: FlatButton(
                                onPressed: () async {
                                  _buildShowModal(context, 'ReportsReset');
                                },
                              child: Text('RESET',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Categories', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.format_align_left),
                            trailing: FlatButton(
                              onPressed: () async {
                                _buildShowModal(context, 'CategoriesReset');
                              },
                              child: Text('RESET',style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey[500]))
                            )
                          ),
                          ListTile(
                            title: Text('Loan List', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.local_atm),
                            trailing: FlatButton(
                              onPressed: () async {
                                _buildShowModal(context, 'LoanReset');
                              },
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
                            leading: Icon(Icons.security),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => MarkdownReader(typeTitle: 'Privacy Policy'),
                                ));
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ),
                          ListTile(
                            title: Text('Terms and Condition', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.branding_watermark),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => MarkdownReader(typeTitle: 'Terms and Condition'),
                                ));
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ),
                          ListTile(
                            title: Text('About Application', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.info),
                            trailing: IconButton(
                              onPressed: () {
                                return showAboutDialog(
                                  context: context,
                                  applicationVersion: '1.0.4',
                                  applicationIcon: FlutterLogo(),
                                  applicationLegalese: 'Trial Version'
                                );
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ),
                          ListTile(
                            onTap: () async {
                              var uriMessage = 'mailto:delacruzjosepaulo@gmail.com?subject=Report a Problem';
                              try {
                                await launch(uriMessage);
                              } catch(err) {
                                print(err);

                              }
                            },
                            title: Text('Report a problem', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                            leading: Icon(Icons.bug_report),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                            )
                          ),
//                          ListTile(
//                              title: Text('Announcement', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
//                              leading: Icon(Icons.new_releases),
//                              trailing: IconButton(
//                                icon: Icon(Icons.arrow_forward_ios),
//                              )
//                          ),
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
