import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:guardian_keyper/consts.dart';

class PlatformService {
  final share = Share.share;
  final wakelockEnable = WakelockPlus.enable;
  final wakelockDisable = WakelockPlus.disable;
  final hasStringsInClipboard = Clipboard.hasStrings;

  Future<String?> copyFromClipboard() async =>
      (await Clipboard.getData(Clipboard.kTextPlain))?.text;

  Future<bool> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> openMarket() =>
      launchUrl(Uri.parse(Platform.isAndroid ? urlPlayMarket : urlAppStore));
}
