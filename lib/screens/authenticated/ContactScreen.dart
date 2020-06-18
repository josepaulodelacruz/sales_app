import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sari_sales/components/ContactBottomModal.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sari_sales/components/EditContactBottomModal.dart';
import 'package:sari_sales/models/Contact.dart';

import 'package:sari_sales/utils/colorParser.dart';
import 'package:sari_sales/providers/contact_data.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreen createState () => _ContactScreen();
}

class _ContactScreen extends State<ContactScreen>{
  bool _isLoading = false;
  List _contacts = [];
  List _searchContactsList = [];

  void initState () {
    super.initState();
    _fetchContacts();
  }

  _fetchContacts () async {
    await Contact.getContact().then((res) {
      setState(() {
        _contacts = res;
        _searchContactsList = res;
      });
    });
  }

  _fuzzySearchContacts (val) {
    setState(() {
      _contacts = val == '' ?
          _searchContactsList:
          _searchContactsList.where((element) => element['name'].toString().toLowerCase().contains(val.toString().toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactData = Provider.of<ContactData>(context);
    return Hero(
      tag: 'contacts',
      child: SafeArea(
        child: Scaffold(
          backgroundColor: getColorFromHex('#f3f3f3'),
          body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Container(
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
                            onChanged: _fuzzySearchContacts,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {

                                  },
                                  icon: Icon(Icons.search),
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
                  Container(
                    child: _contacts.length > 0 ? Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: _contacts.map<Widget>((contact) {
                            int index = _contacts.indexOf(contact);
                            return Container(
                              child: Center(
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.lightBlueAccent,
                                    child: contact['imagePath'] != null ? Center(
                                      child: ClipOval(
                                          child: Image.file(
                                            File(contact['imagePath']),
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    ) : Text('${contact['name'][0]}${contact['name'][1]}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))
                                  ),
                                  title: Text(contact['name'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                                  subtitle: Text(contact['supply']),
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          FlatButton.icon(
                                            onPressed: () async {
                                              var uriMessage = 'tel:${contact['contact']}';
                                              try {
                                                await launch(uriMessage);
                                                setState(() => _isLoading = false);
                                              } catch(err) {
                                                print(err);
                                                setState(() => _isLoading = false);
                                              }
                                            },
                                            icon: Icon(Icons.call, color: Colors.grey[500]), label: Text('Call', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))
                                          ),
                                          FlatButton.icon(
                                            onPressed: () async {
                                              setState(() => _isLoading = true);
                                              var uriMessage = 'sms:${contact['contact']}';
                                              try {
                                                await launch(uriMessage);
                                                setState(() => _isLoading = false);
                                              } catch(err) {
                                                print(err);
                                                setState(() => _isLoading = false);
                                              }
                                            },
                                            icon: Icon(Icons.message, color: Colors.grey[500]), label: Text('Message', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300))
                                          ),
                                          FlatButton.icon(
                                            onPressed: (){
                                              return showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) => SingleChildScrollView(
                                                  child:Container(
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    child: EditContactBottomModal(
                                                      contactUser: {...contact, 'imagePath': contact['imagePath'] == '' ? '' : contact['imagePath']},
                                                      reupdateContacts: () {
                                                        setState(() {});
                                                        _fetchContacts();
                                                      },
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
                    )
                  ),
                ],
              )
            ),
          ))
        )
      )
    );
  }
}

