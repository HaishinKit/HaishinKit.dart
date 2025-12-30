#if canImport(FlutterMacOS)
import FlutterMacOS

extension FlutterPluginRegistrar {
    func messenger() -> FlutterBinaryMessenger {
        return messenger
    }

    func textures() -> FlutterTextureRegistry {
        return textures
    }
}

#endif
