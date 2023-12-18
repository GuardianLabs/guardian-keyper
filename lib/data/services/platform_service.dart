import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:guardian_keyper/consts.dart';

class PlatformService {
  Future<void> wakelockEnable() => WakelockPlus.enable();

  Future<void> wakelockDisable() => WakelockPlus.disable();

  Future<bool> hasStringsInClipboard() => Clipboard.hasStrings();

  Future<bool> openMarket() =>
      launchUrl(Uri.parse(Platform.isAndroid ? urlPlayMarket : urlAppStore));

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

  Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) =>
      Share.share(
        text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
}
