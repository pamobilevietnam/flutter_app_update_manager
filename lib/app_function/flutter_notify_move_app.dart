import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class _AbstractFlutterNotifyMoveApp {
  void showScreenNotifyMoveApp({required String appID, required BuildContext context});
}

class FlutterNotifyMoveApp implements _AbstractFlutterNotifyMoveApp {
  @override
  Future<void> showScreenNotifyMoveApp({required String appID, required BuildContext context}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppNotifyMoveApp(
          appId: appID,
        ),
      ),
    );
  }
}

class AppNotifyMoveApp extends StatefulWidget {
  final String appId;
  const AppNotifyMoveApp({
    Key? key,
    required this.appId,
  }) : super(key: key);

  @override
  State<AppNotifyMoveApp> createState() => _AppNotifyMoveAppState();
}

class _AppNotifyMoveAppState extends State<AppNotifyMoveApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: ElevatedButton(
          child: const Text("Move New App"),
          onPressed: () {
            openPlayStore(widget.appId);
          },
        ),
      ),
    );
  }
}

void openPlayStore(String appId) async {
  final Uri url = Uri.parse("https://play.google.com/store/apps/details?id=$appId");
  await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}
