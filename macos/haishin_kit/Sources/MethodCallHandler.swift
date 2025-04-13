import Foundation
import FlutterMacOS

protocol MethodCallHandler {
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
}
