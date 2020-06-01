// Copyright (c) 2018 Stephan Heilner
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

import Foundation

private class DummyClassToGetBundle {}

public extension UIDevice {
    
    private var currentETag: String? {
        get { UserDefaults.standard.string(forKey: "UIDevice+DisplayName-ETag") }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: "UIDevice+DisplayName-ETag")
            } else {
                UserDefaults.standard.removeObject(forKey: "UIDevice+DisplayName-ETag")
            }
        }
    }
    
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
            let localFileURL = Bundle(for: DummyClassToGetBundle.self).url(forResource: "devices", withExtension: "json")
            do {
                try FileManager.default.createDirectory(at: devicesFileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                if let localFileURL = localFileURL {
                    try FileManager.default.copyItem(at: localFileURL, to: devicesFileURL)
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
    
    func displayName(includeType: Bool = true, deviceIdentifier: String? = nil) -> String {
        checkForUpdates()
        
        switch deviceIdentifier ?? self.deviceIdentifier() {
        case let simulator where simulator.hasPrefix("x86"):
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
            @unknown default:
                return "Unspecified Simulator"
            }
        case let device:
            for (prefix, name) in UIDevice.deviceTypes {
                guard let range = device.range(of: prefix) else { continue }

                return displayName(for: name, prefix: prefix, model: String(device[range.upperBound...]), includeType: includeType)
            }
            return device
        }
    }
    
    private func displayName(for deviceName: String, prefix: String, model: String, includeType: Bool) -> String {
        let unknownDevice = "Unknown \(deviceName)"
        
        guard let devices = UIDevice.devices[deviceName] as? [[String: Any]] else { return unknownDevice }
        
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
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0
                else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
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
        
        UIDevice.isUpdating = true
        
        var request = URLRequest(url: jsonURL)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                let currentETag = httpResponse.allHeaderFields["Etag"] as? String
                else { return }
            
            let needsUpdate: Bool
            
            let cachedETag = self?.currentETag
            if let cachedETag = cachedETag, cachedETag == currentETag {
                // No changes
                needsUpdate = false
            } else if cachedETag == nil {
                // No ETag is cached
                
                let oldKey = "UIDevice+DisplayName Last-Modified"
                if let currentLastModified = httpResponse.allHeaderFields["Last-Modified"] as? String, let cachedLastModified = UserDefaults.standard.string(forKey: oldKey) {
                    // We used to use the last modified date, detect if the file has changed, and store the ETag so we can use that moving forward
                    needsUpdate = cachedLastModified != currentLastModified

                    self?.currentETag = currentETag
                    UserDefaults.standard.removeObject(forKey: oldKey)
                } else {
                    needsUpdate = true
                }
            } else {
                needsUpdate = true
                self?.currentETag = currentETag
            }
            
            if needsUpdate {
                self?.updateDevices(url: jsonURL)
            } else {
                UIDevice.isUpdating = false
                self?.lastUpdated = Date()
            }
        }.resume()
    }
    
    private func updateDevices(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            do {
                if let error = error {
                    print("Unable to update devices.json", error)
                } else if let data = data, let devicesFileURL = UIDevice.devicesFileURL {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    try data.write(to: devicesFileURL, options: .atomic)
                    
                    if let deviceTypes = (json as? [String: Any])?["deviceTypes"] as? [String: String] {
                        UIDevice.deviceTypes = deviceTypes
                    }
                    if let devices = (json as? [String: Any])?["devices"] as? [String: Any] {
                        UIDevice.devices = devices
                    }
                }
            } catch {
                print("Unable to parse/save devices.json", error)
            }
            UIDevice.isUpdating = false
            self?.lastUpdated = Date()
        }.resume()
    }
    
}
