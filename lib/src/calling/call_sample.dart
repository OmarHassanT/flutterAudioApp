import 'package:flutter/material.dart';
import 'package:videoAppFluuter/src/calling/webrtc_client.dart';
import 'dart:core';
import 'signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'random_string.dart';

class CallSample extends StatefulWidget {
  static String tag = 'call_sample';

  final String ip;

  CallSample({Key key, @required this.ip}) : super(key: key);

  @override
  _CallSampleState createState() => _CallSampleState();
}

class _CallSampleState extends State<CallSample> {
  // Signaling _signaling;
  String _selfId = "1";
  String _peerId = "2";
   String channelId="123";
  // RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  // RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  
  String media;
  bool _inCalling = false;
  bool isSpeaker = true;
  bool mute = false;
  WebRtcClient _webRtcClient;
  // final String serverIP;

  _CallSampleState({Key key});

  @override
  initState() {
    super.initState();
       _webRtcClient = WebRtcClient(channelId, peerId: _peerId, selfId: _selfId);

    // initRenderers();
    // _connect();

  }

  // initRenderers() async {
  //   await _localRenderer.initialize();
  //   await _remoteRenderer.initialize();

  // }

  @override
  deactivate() {
    super.deactivate();
    // if (_signaling != null) _signaling.close();
    // _localRenderer.dispose();
    // _remoteRenderer.dispose();
  }
  // void _connect() async {
  //   if (_signaling == null) {
  //     _signaling = Signaling(_selfId)..connect();

  //     _signaling.onStateChange = (SignalingState state) {
  //       switch (state) {
  //         case SignalingState.CallStateNew:
  //           this.setState(() {
  //             _inCalling = true;
  //           });
         
            
  //           break;
  //         case SignalingState.CallStateBye:
  //           this.setState(() {
  //             _localRenderer.srcObject = null;
  //             _remoteRenderer.srcObject = null;
  //             _inCalling = false;
  //           });
  //           break;
  //         case SignalingState
  //             .CallStateInvite: ///////////////////cases of ringing
  //         case SignalingState.CallStateConnected:
  //         break;
  //         case SignalingState.CallStateRinging:
        
  //         break;
  //         case SignalingState.ConnectionClosed:
  //         case SignalingState.ConnectionError:
  //         case SignalingState.ConnectionOpen:
  //           break;
  //       }
  //     };

  //     _signaling.onPeersUpdate = ((event) {
  //       this.setState(() {
  //         _selfId = event['self'];
  //       });
  //     });

  //     _signaling.onLocalStream = ((stream) {
  //       _localRenderer.srcObject = stream;
  //     });

  //     _signaling.onAddRemoteStream = ((stream) {
  //       _remoteRenderer.srcObject = stream;
  //     });

  //     _signaling.onRemoveRemoteStream = ((stream) {
  //       _remoteRenderer.srcObject = null;
  //     });
  //   }
  // }
  // _invitePeer(context, peerId, media) async {
  //   if (_signaling != null && peerId != _selfId && peerId!=null) {
  //     _signaling.invite(peerId, media);
  //   }
  // }

  // _hangUp() {
  //   if (_signaling != null) {
  //     _signaling.close();
  //      this.setState(() {
  //             _localRenderer.srcObject = null;
  //             _remoteRenderer.srcObject = null;
  //             _inCalling = false;
  //           });
  //               }

  //     _signaling.bye(_peerId);
  // }

  // _muteMic(mute) {
  //   _signaling.microphoneMute(mute);
  // }

  // _speakerEnable(speakerEnable) {
  //   _signaling.speakerPhone(speakerEnable);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Id:$channelId  ss $_selfId'),
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
                           _webRtcClient.leave();
                        },
                        tooltip: 'Hangup',
                        child: Icon(Icons.call_end),
                        backgroundColor: Colors.pink,
                      ),
                      FloatingActionButton(
                        child: Icon(mute ? Icons.mic_off : Icons.mic),
                        onPressed: () {
                           _webRtcClient.toggleMic(mute);
                          setState(() {
                            mute = !mute;
                          });
                         
                        },
                      ),
                      FloatingActionButton(
                        child: Icon(
                            isSpeaker ? Icons.volume_up : Icons.volume_down),
                        tooltip: 'Speaker',
                        onPressed: () {
                       _webRtcClient.toggleSpeaker(isSpeaker);
                          setState(() {
                            isSpeaker = !isSpeaker;
                          });
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
                        onChanged: (channelId) {
                          setState(() {
                            this.channelId=channelId;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // media = 'audio';
                          _webRtcClient.invitPeer();
                        },

                        tooltip: 'invite',
                      ),
                        SizedBox(height: 20,width: 20,),
                        IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                         
                          _webRtcClient.join();

                        },
                        tooltip: 'join ',
                      ),
                   
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed:(){
                           _webRtcClient.leave();
                        },
                        tooltip: 'Hangup',
                        child: Icon(Icons.call_end),
                        backgroundColor: Colors.pink,
                      ),
                      FloatingActionButton(
                        child: Icon(mute ? Icons.mic_off : Icons.mic),
                        onPressed: () {
                           _webRtcClient.toggleMic(mute);
                          setState(() {
                            mute = !mute;
                          });
                         
                        },
                      ),
                      FloatingActionButton(
                        child: Icon(
                            isSpeaker ? Icons.volume_up : Icons.volume_down),
                        tooltip: 'Speaker',
                        onPressed: () {
                       _webRtcClient.toggleSpeaker(isSpeaker);
                          setState(() {
                            isSpeaker = !isSpeaker;
                          });
                        },
                      ),
                       
                    ]) ],
                  ),
                ),
              ));
  }
}
