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
    
    private var lastUpdated: Date? {
        get {
            let timeInterval = UserDefaults.standard.double(forKey: "UIDevice+DisplayName-LastUpdated")
            return timeInterval > 0 ? Date(timeIntervalSince1970: timeInterval) : nil
        }
        set {
            if let timeInterval = newValue?.timeIntervalSince1970 {
                UserDefaults.standard.set(timeInterval, forKey: "UIDevice+DisplayName-LastUpdated")
            } else {
                UserDefaults.standard.removeObject(forKey: "UIDevice+DisplayName-LastUpdated")
            }
        }
    }
    
    private static var isUpdating = false
    
    private static let devicesFileURL: URL? = {
        guard let devicesFileURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last?.appendingPathComponent("UIDevice").appendingPathComponent("devices.json")
        else { return nil }
        
        if !FileManager.default.fileExists(atPath: devicesFileURL.path) {
            let localFileURL = Bundle.uiDeviceDisplayName.url(forResource: "devices", withExtension: "json")
            do {
                try FileManager.default.createDirectory(at: devicesFileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                if let localFileURL = localFileURL {
                    try FileManager.default.copyItem(at: localFileURL, to: devicesFileURL)
                    if let creationDate = DateFormatter.rfc.date(from: "Sun, 01 Nov 2020 00:00:00 GMT") {
                        try FileManager.default.setAttributes([.creationDate: creationDate], ofItemAtPath: devicesFileURL.path)
                    }
                }
            } catch {
                print("Error copying devices.json file", error)
                return localFileURL
            }
        }
        
        return devicesFileURL
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
        guard let devicesFileURL = devicesFileURL else { return [:] }
        
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
        checkForUpdates()
        
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
            guard let deviceIdentifier = device.keys.first, deviceIdentifier == "\(prefix)\(model)" else { continue }
            
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
    
    private func checkForUpdates() {
        guard !UIDevice.isUpdating,
              let jsonURL = URL(string: "https://cdn.churchofjesuschrist.org/mobile/devices.json")
        else { return }
        
        if let lastUpdated = lastUpdated, Date().timeIntervalSince(lastUpdated) < 604800 {
            // Only check once every week (604800 seconds) at most
            return
        }
        
        var request = URLRequest(url: jsonURL)
        if let fileURL = UIDevice.devicesFileURL, let date = try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.creationDate] as? Date {
            request.setValue(DateFormatter.rfc.string(from: date), forHTTPHeaderField: "If-Modified-Since")
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            let response = response as? HTTPURLResponse
            do {
                if let response = response, response.statusCode == 304 {
                    // Do nothing, file hasn't changed
                    self?.lastUpdated = Date()
                } else if let error = error {
                    print("Unable to update devices.json", error)
                } else if let data = data, let devicesFileURL = UIDevice.devicesFileURL {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    try data.write(to: devicesFileURL, options: .atomic)
                    
                    if let lastModifiedString = response?.allHeaderFields["Last-Modified"] as? String, let modifiedDate = DateFormatter.rfc.date(from: lastModifiedString) {
                        try? FileManager.default.setAttributes([.creationDate: modifiedDate], ofItemAtPath: devicesFileURL.path)
                    }
                    
                    if let deviceTypes = (json as? [String: Any])?["deviceTypes"] as? [String: String] {
                        UIDevice.deviceTypes = deviceTypes
                    }
                    if let devices = (json as? [String: Any])?["devices"] as? [String: Any] {
                        UIDevice.devices = devices
                    }
                    
                    self?.lastUpdated = Date()
                }
            } catch {
                print("Unable to parse/save devices.json", error)
            }
            UIDevice.isUpdating = false
        }.resume()
    }
    
}

private extension DateFormatter {
    static let rfc: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

#endif
