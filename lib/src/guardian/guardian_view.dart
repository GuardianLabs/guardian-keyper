import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'guardian_model.dart';
import '../settings/settings_controller.dart';

class GuardianView extends StatefulWidget {
  const GuardianView({Key? key}) : super(key: key);

  @override
  State<GuardianView> createState() => _GuardianViewState();
}

class _GuardianViewState extends State<GuardianView> {
  final _authToken = AuthToken.generate();
  late final Uint8List _qr;

  @override
  void initState() {
    super.initState();
    final myPubKey = context.read<SettingsController>().keyPair.publicKey;
    var qr = [0, 0, 0, 0];
    qr.addAll(_authToken.data);
    qr.addAll(myPubKey);
    qr.addAll(AuthToken.generate().data); //TBD: add second pubKey
    _qr = Uint8List.fromList(qr);
  }

  @override
  Widget build(BuildContext context) {
    return QrImage(data: base64.encode(_qr));
  }
}
