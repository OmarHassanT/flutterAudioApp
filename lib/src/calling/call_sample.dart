import 'package:flutter/material.dart';
import 'dart:core';
import 'signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'random_string.dart';

class CallSample extends StatefulWidget {
  static String tag = 'call_sample';

  final String ip;

  CallSample({Key key, @required this.ip}) : super(key: key);

  @override
  _CallSampleState createState() => _CallSampleState(serverIP: ip);
}

class _CallSampleState extends State<CallSample> {
  Signaling _signaling;
  String _selfId = randomNumeric(6);
  var _peerId = "";
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  
  String media;
  bool _inCalling = false;
  bool isSpeaker = true;
  bool mute = false;
  final String serverIP;

  _CallSampleState({Key key, @required this.serverIP});

  @override
  initState() {
    super.initState();
    initRenderers();
    _connect();

  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

  }

  @override
  deactivate() {
    super.deactivate();
    if (_signaling != null) _signaling.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }
  void _connect() async {
    if (_signaling == null) {
      _signaling = Signaling(_selfId)..connect();

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
                         this._showMyDialog();

            
            break;
          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
            break;
          case SignalingState
              .CallStateInvite: ///////////////////cases of ringing
          case SignalingState.CallStateConnected:
          break;
          case SignalingState.CallStateRinging:
          this.setState(() {
              _inCalling = true;
            });
         
          break;
          case SignalingState.ConnectionClosed:
          case SignalingState.ConnectionError:
          case SignalingState.ConnectionOpen:
            break;
        }
      };

      _signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _selfId = event['self'];
        });
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    //  barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('caming call'),
        content: SingleChildScrollView(
          child:Text('accept this call?'),

        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              _signaling.accept("audio");
              Navigator.of(context).pop();
            },
          ),
           FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  _invitePeer(context, peerId, media) async {
    if (_signaling != null && peerId != _selfId && peerId!=null) {
      _signaling.invite(peerId, media);
    }
  }

  _hangUp() {
    if (_signaling != null) {
      _signaling.close();
       this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
                }

      _signaling.bye(_peerId);
  }

  _muteMic(mute) {
    _signaling.microphoneMute(mute);
  }

  _speakerEnable(speakerEnable) {
    _signaling.speakerPhone(speakerEnable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Id:$_selfId'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: null,
              tooltip: 'setup',
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _inCalling
            ? SizedBox(
                width: 200.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed:(){
                           _hangUp();
                        },
                        tooltip: 'Hangup',
                        child: Icon(Icons.call_end),
                        backgroundColor: Colors.pink,
                      ),
                      FloatingActionButton(
                        child: Icon(mute ? Icons.mic_off : Icons.mic),
                        onPressed: () {
                          setState(() {
                            mute = !mute;
                          });
                          _muteMic(mute);
                        },
                      ),
                      FloatingActionButton(
                        child: Icon(
                            isSpeaker ? Icons.volume_up : Icons.volume_down),
                        tooltip: 'Speaker',
                        onPressed: () {
                          setState(() {
                            isSpeaker = !isSpeaker;
                            // print()
                          });
                          _speakerEnable(isSpeaker);
                        },
                      ),
                       
                    ]))
            : null,
        body: _inCalling
            ? Center(
                child: Text(
                  "Voice call running...",
                  style: TextStyle(color: Colors.green, fontSize: 40),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter Id of the reciver'),
                        onChanged: (reciverId) {
                          setState(() {
                            _peerId = reciverId ?? "null";
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () {
                          media = 'audio';
                          _invitePeer(context, _peerId, media);

                        },
                        tooltip: 'Audio calling',
                      ),
                    ],
                  ),
                ),
              ));
  }
}
