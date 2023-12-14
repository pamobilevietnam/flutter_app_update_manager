import 'package:flutter/services.dart';
import 'package:flutter_update_app/app_info/imp_class/app_remote_info.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import '../app_info/imp_class/app_info.dart';

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
    await AppDeviceInfo().initInfo();
    await AppRemoteInfo().initInfo();
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Chào mừng bạn đến với phiên bản mới nhất của ứng dụng của chúng tôi!",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                      ),
                      Text("""
                  
Chúng tôi đã cập nhật ứng dụng để cải thiện trải nghiệm của bạn. Để tiếp tục sử dụng các tính năng mới và đảm bảo tính ổn định, vui lòng cập nhật ứng dụng của bạn ngay bây giờ.
Cảm ơn bạn đã luôn ủng hộ chúng tôi! 🚀
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
                      if (widget.obligatory)
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
