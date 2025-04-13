import Foundation
#if canImport(Flutter)
import Flutter
#endif
#if canImport(FlutterMacOS)
import FlutterMacOS
#endif

protocol MethodCallHandler {
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
}
