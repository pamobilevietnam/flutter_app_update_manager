import 'package:package_info/package_info.dart';

import '../abs_class/abs_app_device_info.dart';

class AppDeviceInfo implements AbstractAppDeviceInfo {
  PackageInfo? packageInfo;

  static final AppDeviceInfo _singleton = AppDeviceInfo._internal(
    null,
  );
  factory AppDeviceInfo() {
    return _singleton;
  }
  AppDeviceInfo._internal(this.packageInfo);

  @override
  Future<void> initInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  int getCurrentCodeVersion() {
    try {
      final int resultValue = int.parse(packageInfo?.buildNumber ?? "");
      return resultValue;
    } catch (e) {
      return 0;
    }
  }

  @override
  void showInfoApp() {
    print('App Name: ${packageInfo?.appName}');
    print('Package Name: ${packageInfo?.packageName}');
    print('Version: ${packageInfo?.version}');
    print('Build Number: ${packageInfo?.buildNumber}');
  }
}
