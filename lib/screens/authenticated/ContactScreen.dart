import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sari_sales/components/ContactBottomModal.dart';

import 'package:sari_sales/utils/colorParser.dart';

class ContactScreen extends StatefulWidget {
  @override
  createState () => _ContactScreen();
}

class _ContactScreen extends State<ContactScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Hero(
      tag: 'contacts',
      child: SafeArea(
        child: Scaffold(
          backgroundColor: getColorFromHex('#f3f3f3'),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
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
                                  blurRadius: 10,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ]
                          ),
                          child: Container(
                              alignment: Alignment.topLeft,
                              child: FlatButton.icon(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: Colors.white), label: Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)))
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20, left: 20, top: MediaQuery.of(context).size.height * 0.10),
                        height: 60,
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
                                hintText: 'Search Item'),
                          )
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton.icon(onPressed: null, icon: Icon(Icons.person, color: Colors.grey[500]), label: Text('Contact List', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                        FlatButton.icon(onPressed: (){
                          return showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => SingleChildScrollView(
                                child:Container(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: ContactBottomModal(),
                                )
                            )
                          );
                        }, icon: Icon(Icons.person_add, color: Colors.grey[500]), label: Text('Add Contact', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300)))
                      ],
                    )
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          Container(
                            child: Center(
                              child: ExpansionTile(
                                leading: CircleAvatar(radius: 25),
                                title: Text('Jose Paulo Dela Cruz', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                subtitle: Text('Company Name'),
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        FlatButton.icon(onPressed: (){}, icon: Icon(Icons.call, color: Colors.grey[500]), label: Text('Call', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                        FlatButton.icon(onPressed: (){}, icon: Icon(Icons.message, color: Colors.grey[500]), label: Text('Message', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                        FlatButton.icon(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.grey[500]), label: Text('Edit', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                      ],
                                    )
                                  )
                                ],
                              ),
                            )
                          ),
                          Container(
                              child: Center(
                                child: ExpansionTile(
                                  leading: CircleAvatar(radius: 25),
                                  title: Text('Jose Paulo Dela Cruz', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                  subtitle: Text('Company Name'),
                                  children: <Widget>[
                                    Container(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            FlatButton.icon(onPressed: (){}, icon: Icon(Icons.call, color: Colors.grey[500]), label: Text('Call', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                            FlatButton.icon(onPressed: (){}, icon: Icon(Icons.message, color: Colors.grey[500]), label: Text('Message', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                            FlatButton.icon(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.grey[500]), label: Text('Edit', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              )
                          ),
                        ]
                      ).toList(),
                    )
                  )
                ],
              )
            ),
          )
        )
      )
    );
  }
}

