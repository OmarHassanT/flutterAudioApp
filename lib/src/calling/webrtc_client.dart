import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:videoAppFluuter/src/calling/signaling.dart';

class WebRtcClient {
  String channelId;
  WebRtcClient(this.channelId, {@required this.selfId ,@required  this.peerId}) {
    _initRenderers();
  }

  Signaling _signaling;
  String selfId;
  String peerId;

  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  String media = "audio";
  bool _inCalling = false;

  join() {
    //check if channel id exist in database
    //if not
    //call inivite 
    //else only connect 
    _connect();
  }

  invitPeer() {
    _invitePeer(peerId, media);
  }

  leave() {
    _hangUp();
  }

  toggleMic(bool mute) {
    _muteMic(!mute);
  }

  toggleSpeaker(bool mute) {
    _muteSpeaker(!mute);
  }

  disposeClient() {
    _hangUp();
    if (_signaling != null) _signaling.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    // _signaling = Signaling(selfId, channelId);

  }

  void _connect() async {
    if (_signaling == null) {
     _signaling= Signaling(selfId, channelId)..connect();

      // _signaling.onStateChange = (SignalingState state) {
      //   switch (state) {
      //     case SignalingState.CallStateNew:
      //       _inCalling = true;

      //       break;
      //     case SignalingState.CallStateBye:
      //       _localRenderer.srcObject = null;
      //       _remoteRenderer.srcObject = null;
      //       _inCalling = false;

      //       break;
      //     case SignalingState
      //         .CallStateInvite: ///////////////////cases of ringing
      //     case SignalingState.CallStateConnected:
      //       break;
      //     case SignalingState.CallStateRinging:
      //       break;
      //     case SignalingState.ConnectionClosed:
      //     case SignalingState.ConnectionError:
      //     case SignalingState.ConnectionOpen:
      //       break;
      //   }
      // };

      // _signaling.onPeersUpdate = ((event) {
      //   _selfId = event['self'];
      // });

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

  _invitePeer(peerId, media) async {
    if (_signaling != null && peerId != selfId && peerId != null) {
      _signaling.invite(peerId, media);
    }
  }

   _hangUp() {
    if (_signaling != null) {
      _signaling.close();

      _localRenderer.srcObject = null;
      _remoteRenderer.srcObject = null;
      _inCalling = false;
    }

    _signaling.bye(peerId);
  }

  _muteMic(mute) {
    _signaling.microphoneMute(mute);
  }

  _muteSpeaker(bool mute) {
    mute ? _signaling.speakerMute(0) : _signaling.speakerMute(1);
  }
  // _speakerEnable(speakerEnable) {
  //   _signaling.speakerPhone(speakerEnable);
  // }

}
