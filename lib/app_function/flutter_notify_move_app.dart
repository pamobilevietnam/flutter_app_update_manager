import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class _AbstractFlutterNotifyMoveApp {
  void showScreenNotifyMoveApp({
    required String iosId,
    required String androidId,
    required BuildContext context,
    required Widget Function(Function) screenBuilder,
  });
}

class FlutterNotifyMoveApp implements _AbstractFlutterNotifyMoveApp {
  @override
  Future<void> showScreenNotifyMoveApp({
    String? iosId,
    String? androidId,
    required BuildContext context,
    required Widget Function(Function) screenBuilder,
  }) async {
    if (Platform.isIOS && iosId?.trim() != null && iosId?.trim() != "") {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return screenBuilder(
              () => openAppStore(
                iosId ?? "",
              ),
            );
          },
        ),
      );
    } else if (Platform.isAndroid && androidId?.trim() != null && androidId?.trim() != "") {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => screenBuilder(
            () => openPlayStore(
              androidId ?? "",
            ),
          ),
        ),
      );
    }
  }
}

void openPlayStore(String appId) async {
  final Uri url = Uri.parse("https://play.google.com/store/apps/details?id=$appId");
  await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}

void openAppStore(String appId) async {
  final Uri url = Uri.parse("https://apps.apple.com/app/id$appId");
  await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}
