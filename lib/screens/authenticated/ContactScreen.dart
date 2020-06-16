import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sari_sales/components/ContactBottomModal.dart';
import 'package:provider/provider.dart';
import 'package:sari_sales/models/Contact.dart';

import 'package:sari_sales/utils/colorParser.dart';
import 'package:sari_sales/providers/contact_data.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreen createState () => _ContactScreen();
}

class _ContactScreen extends State<ContactScreen>{

  void initState () {
    super.initState();
    _fetchContacts();
  }

  _fetchContacts () async {
    return await Contact.getContact();
  }

  @override
  Widget build(BuildContext context) {
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
                                  child: ContactBottomModal(
                                    reupdateContacts: () async {
                                      setState(() {});
                                      _fetchContacts();
                                    }
                                  ),
                                )
                            )
                          );
                        }, icon: Icon(Icons.person_add, color: Colors.grey[500]), label: Text('Add Contact', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300)))
                      ],
                    )
                  ),
                  FutureBuilder(
                    future: _fetchContacts(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        return snapshot.data.length > 0 ? Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: ListTile.divideTiles(
                              context: context,
                              tiles: snapshot.data.map<Widget>((contact) {
                                print(contact);
                                return Container(
                                  child: Center(
                                    child: ExpansionTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        child: contact['imagePath'] != null ? Center(
                                          child: ClipOval(
                                              child: Image.file(
                                                File(contact['imagePath']),
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.fill,
                                              )
                                          ),
                                        ) : Text('${contact['name'][0]}${contact['name'][1]}')
                                      ),
                                      title: Text(contact['name'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                      subtitle: Text(contact['supply']),
                                      children: <Widget>[
                                        Container(
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              FlatButton.icon(onPressed: (){}, icon: Icon(Icons.call, color: Colors.grey[500]), label: Text('Call', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                              FlatButton.icon(onPressed: (){}, icon: Icon(Icons.message, color: Colors.grey[500]), label: Text('Message', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))),
                                              FlatButton.icon(
                                                onPressed: (){
                                                  return showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (context) => SingleChildScrollView(
                                                      child:Container(
                                                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                        child: ContactBottomModal(
                                                          contactUser: contact,
                                                        ),
                                                      )
                                                    )
                                                  );
                                                },
                                                icon: Icon(Icons.edit, color: Colors.grey[500]), label: Text('Edit', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))
                                              ),
                                            ],
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                );
                              }).toList(),
                            ).toList(),
                          )
                        ) :  Card(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          title: Text('No Save Contacts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                          subtitle: Text('Please add Contacts.'),
                          trailing: Icon(Icons.warning),
                          )
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              )
            ),
          )
        )
      )
    );
  }
}

