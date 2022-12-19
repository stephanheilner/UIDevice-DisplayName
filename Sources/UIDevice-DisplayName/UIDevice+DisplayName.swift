// Copyright (c) 2021 Stephan Heilner
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if canImport(UIKit)

import UIKit

private class DummyClassToGetBundle {}

public extension UIDevice {
    
    private static let devicesFileURL: URL? = {
        return Bundle.uiDeviceDisplayName.url(forResource: "devices", withExtension: "json")
    }()
    
    private static var deviceTypes: [String: String] = {
        guard let devicesFileURL = devicesFileURL
        else { return [:] }
        
        do {
            let jsonData = try Data(contentsOf: devicesFileURL)
            return try (JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any])?["deviceTypes"] as? [String: String] ?? [:]
        } catch {
            print("Unable to load devices", error)
            return [:]
        }
    }()
    
    private static var devices: [String: Any] = {
        guard let devicesFileURL = devicesFileURL
        else { return [:] }
        
        do {
            let jsonData = try Data(contentsOf: devicesFileURL)
            return (try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any])?["devices"] as? [String: Any] ?? [:]
        } catch {
            print("Unable to load devices", error)
            return [:]
        }
    }()
    
    private var simulatorName: String {
        switch userInterfaceIdiom {
        case .unspecified:
            return "Unspecified Simulator"
        case .phone:
            return "iPhone Simulator"
        case .pad:
            return "iPad Simulator"
        case .tv:
            return "Apple TV Simulator"
        case .carPlay:
            return "CarPlay Simulator"
        case .mac:
            return "Mac Simulator"
        @unknown default:
            return "Unspecified Simulator"
        }
    }
    
    func displayName(includeType: Bool = true, deviceIdentifier: String? = nil) -> String {
        switch deviceIdentifier ?? self.deviceIdentifier() {
        case let x86Simulator where x86Simulator.hasPrefix("x86"):
            return simulatorName
        case let armSimulator where armSimulator.hasPrefix("arm"):
            return simulatorName
        case let i386Simulator where i386Simulator.contains("386"):
            return simulatorName
        case let device:
            // This filtering is necessary because there are multiple device types that start with "Mac", including one that is called "Mac"
            let filteredDeviceTypes = UIDevice.deviceTypes.filter { device.hasPrefix($0.key) }
            if let longestKey = filteredDeviceTypes.keys.max(by: { $1.count > $0.count }),
               let value = filteredDeviceTypes[longestKey],
               let range = device.range(of: longestKey) {
                return displayName(for: value, prefix: longestKey, model: String(device[range.upperBound...]), includeType: includeType)
            }
            return device
        }
    }
    
    private func displayName(for deviceName: String, prefix: String, model: String, includeType: Bool) -> String {
        let unknownDevice = "Unknown \(deviceName)"
        
        guard let devices = UIDevice.devices[prefix] as? [[String: Any]]
        else { return unknownDevice }
        
        var name: String?
        var type: String?
        
        for device in devices {
            guard let deviceIdentifier = device.keys.first,
                  deviceIdentifier == "\(prefix)\(model)"
            else { continue }
            
            for (key, value) in device.values.first as? [String: String] ?? [:] {
                switch key {
                case "name":
                    name = value
                case "type":
                    type = value
                default: ()
                }
            }
        }
        
        if let name = name {
            if includeType, let type = type {
                return "\(deviceName) \(name) (\(type))"
            }
            return "\(deviceName) \(name)"
        }
        return unknownDevice
    }
    
    private func deviceIdentifier() -> String {
        var identifierString: String?
        
        // This if #available is necessary to prevent a compiler error.
        // The error shows up even though the package version is set to iOS 14.
        // Perhaps UIDevice itself supports versions older than iOS 14?
        if #available(iOS 14, *) {
            if ProcessInfo.processInfo.isiOSAppOnMac {
                var modelSize = 0
                sysctlbyname("hw.model", nil, &modelSize, nil, 0)
                var model = Array<Int8>(repeating: 0, count: modelSize)
                sysctlbyname("hw.model", &model, &modelSize, nil, 0)
                identifierString = String(utf8String: model)
            } else {
                var machineSize = 0
                sysctlbyname("hw.machine", nil, &machineSize, nil, 0)
                var machine = Array<Int8>(repeating: 0, count: machineSize)
                sysctlbyname("hw.machine", &machine, &machineSize, nil, 0)
                identifierString = String(utf8String: machine)
            }
        }

        if let identifierString = identifierString {
            return identifierString
        } else {
            var systemInfo = utsname()
            uname(&systemInfo)
            let mirror = Mirror(reflecting: systemInfo.machine)
            return mirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0
                else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
    }
}

#endif
