import 'platform_interface_haishin_kit.dart';

class HaishinKit {
  Future<String?> getPlatformVersion() {
    return HaishinKitPlatformInterface.instance.getPlatformVersion();
  }
}
