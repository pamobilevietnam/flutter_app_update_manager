/// Lấy info app trong máy
abstract class AbstractAppDeviceInfo {
  /// khởi tạo package info app.
  Future<void> initInfo();

  /// get CurrentCodeVersion của app đang có trong máy.
  int getCurrentCodeVersion();

  /// print info app đang có trong máy.
  void showInfoApp();
}
