import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import '../app_info/imp_class/app_info.dart';
import '../app_info/imp_class/app_remote_info.dart';

abstract class _AbstractFlutterUpdateApp {
  Future<void> initInfo();
  Future<void> showScreenUpdateApp(
    BuildContext context, {
    Function? onSkipUpdate,
    Widget? Function(
      Function? onSkipUpdate,
      Function? onUpdate,
    )? screenUpdateBuilder,
    bool obligatory = false,
  });
}

class FlutterUpdateApp implements _AbstractFlutterUpdateApp {
  @override
  Future<void> initInfo() async {
    if (Platform.isAndroid) {
      await AppDeviceInfo().initInfo();
      await AppRemoteInfo().initInfo();
    }
  }

  @override
  Future<void> showScreenUpdateApp(
    BuildContext context, {
    Function? onSkipUpdate,
    Widget? Function(
      Function? onSkipUpdate,
      Function? onUpdate,
    )? screenUpdateBuilder,
    bool obligatory = false,
  }) async {
    if (Platform.isAndroid) {
      if (AppDeviceInfo().getCurrentCodeVersion() != AppRemoteInfo().getCurrentCodeVersion()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WillPopScope(
              onWillPop: () {
                SystemNavigator.pop();
                return Future.value(false);
              },
              child: AppUpdate(
                onSkipUpdate: onSkipUpdate,
                obligatory: obligatory,
                screenUpdate: screenUpdateBuilder?.call(onSkipUpdate, gotoUpdate),
              ),
            ),
          ),
        );
      } else {
        onSkipUpdate?.call();
      }
    } else {
      onSkipUpdate?.call();
    }
  }
}

class AppUpdate extends StatefulWidget {
  final Function? onSkipUpdate;
  final bool obligatory;
  final Widget? screenUpdate;
  const AppUpdate({
    Key? key,
    this.onSkipUpdate,
    required this.obligatory,
    this.screenUpdate,
  }) : super(key: key);

  @override
  State<AppUpdate> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.screenUpdate ??
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to our latest version!",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                      ),
                      Text("""
                  
We have updated the application to enhance your experience. To continue using the new features and ensure stability, please update your app now. 
Thank you for your ongoing support! 🚀
                  """, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            gotoUpdate();
                          },
                          child: const Text("Update"),
                        ),
                      ),
                      if (!widget.obligatory)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onSkipUpdate?.call();
                            },
                            child: const Text("Skip"),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      icon: const Icon(Icons.close),
                    ))
              ],
            ),
          ),
        );
  }
}

Future<void> gotoUpdate() async {
  await InAppUpdate.performImmediateUpdate().then(
    (value) {
      print("update done");
    },
  ).catchError((e) {
    print("error: $e");
  });
  await InAppUpdate.checkForUpdate().then((value) {
    print(value.availableVersionCode);
    print(value.clientVersionStalenessDays);
    print(value.flexibleAllowedPreconditions);
    print(value.flexibleUpdateAllowed);
    print(value.installStatus);
    print(value.packageName);
    print(value.updateAvailability);
    print(value.updatePriority);
  });
  InAppUpdate.checkForUpdate();

  // SystemNavigator.pop();
}
