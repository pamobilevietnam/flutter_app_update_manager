import 'package:in_app_update/in_app_update.dart';

import '../abs_class/abs_app_remote_info.dart';

class AppRemoteInfo implements AbstractAppRemoteInfo {
  AppUpdateInfo? appUpdateInfo;

  static final AppRemoteInfo _singleton = AppRemoteInfo._internal(
    null,
  );
  factory AppRemoteInfo() {
    return _singleton;
  }
  AppRemoteInfo._internal(this.appUpdateInfo);

  @override
  Future<void> initInfo() async {
    appUpdateInfo = await InAppUpdate.checkForUpdate();
  }

  @override
  int getCurrentCodeVersion() {
    return appUpdateInfo?.availableVersionCode ?? 0;
  }
}
