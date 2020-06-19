import 'dart:core';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'src/calling/call_sample.dart';
// import 'src/route_item.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

// enum DialogDemoAction {
//   cancel,
//   connect,
// }

class _MyAppState extends State<MyApp> {
  // List<RouteItem> items;
  // String _server = '';
  // SharedPreferences _prefs;

  // bool _datachannel = false;
  @override
  initState() {
    super.initState();
    // _initData();
    // _initItems();
  }

  // _buildRow(context, item) {
  //   return ListBody(children: <Widget>[
  //     ListTile(
  //       title: Text(item.title),
  //       onTap: () => item.push(context),
  //       trailing: Icon(Icons.arrow_right),
  //     ),
  //     Divider()
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CallSample(ip: 'demo.cloudwebrtc.com'),
    );
  }

  // _initData() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _server = _prefs.getString('server') ?? 'demo.cloudwebrtc.com';
  //   });
  // }

  // void showDemoDialog<T>({BuildContext context, Widget child}) {
  //   showDialog<T>(
  //     context: context,
  //     builder: (BuildContext context) => child,
  //   ).then<void>((T value) {
  //     // The value passed to Navigator.pop() or null.
  //     if (value != null) {
  //       if (value == DialogDemoAction.connect) {
  //         _prefs.setString('server', _server);
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => //_datachannel
  //                     //? DataChannelSample(ip: _server)
  //                    // :
  //                    CallSample(ip: 'demo.cloudwebrtc.com')));
  //       }
  //     }
  //   });
  // }

  // _showAddressDialog(context) {
  //   showDemoDialog<DialogDemoAction>(
  //       context: context,
  //       child: AlertDialog(
  //           title: const Text('Enter server address:'),
  //           content: TextField(
  //             onChanged: (String text) {
  //               setState(() {
  //                 _server = text;
  //               });
  //             },
  //             decoration: InputDecoration(
  //               hintText: _server,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //                 child: const Text('CANCEL'),
  //                 onPressed: () {
  //                   Navigator.pop(context, DialogDemoAction.cancel);
  //                 }),
  //             FlatButton(
  //                 child: const Text('CONNECT'),
  //                 onPressed: () {
  //                   Navigator.pop(context, DialogDemoAction.connect);
  //                 })
  //           ]));
  // }

  // _initItems() {
  //   items = <RouteItem>[
  //     // RouteItem(
  //     //     title: 'Basic API Tests',
  //     //     subtitle: 'Basic API Tests.',
  //     //     push: (BuildContext context) {
  //     //       Navigator.push(
  //     //           context,
  //     //           MaterialPageRoute(
  //     //               builder: (BuildContext context) => BasicSample()));
  //     //     }),
  //     RouteItem(
  //         title: 'P2P Call',
  //         subtitle: 'P2P Call',
  //         push: (BuildContext context) {
  //           // _datachannel = false;
  //           _showAddressDialog(context);
  //         }),
  //     // RouteItem(
  //     //     title: 'Data Channel Sample',
  //     //     subtitle: 'P2P Data Channel.',
  //     //     push: (BuildContext context) {
  //     //       // _datachannel = true;
  //     //       _showAddressDialog(context);
  //     //     }),
  //   ];
  // }
}
