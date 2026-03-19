//
//  DeviceManager.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 19.03.26.
//


import UIKit

public final class DeviceManager {
    
    public static let shared = DeviceManager()
    
    public init() {}
    
    // MARK: - Device Info
    
    public var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    }
    
    public var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        #if targetEnvironment(simulator)
        return "Simulator" + (ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? identifier)
        #else
            return identifier
        #endif
    }
    
    public var devicePlatform: String {
        "iOS"
    }
    
    public var deviceOs: String {
        "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
    }
    
    public var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }
}
