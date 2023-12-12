/// Lấy info app trên CH Play
abstract class AbstractAppRemoteInfo {
  /// khởi tạo package info app.
  Future<void> initInfo();

  /// get CurrentCodeVersion của app trên CH Play.
  int getCurrentCodeVersion();
}
