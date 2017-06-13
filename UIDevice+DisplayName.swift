//  UIDevice+DisplayName.m
//
// Copyright (c) 2013 Stephan Heilner
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

public extension UIDevice {
    
    private static let WiFi = "Wi-Fi"
    private static let GSM = "GSM"
    private static let CDMA = "CDMA"
    private static let GSM_CMDA = "GSM+CDMA"
    private static let Cellular = "Cellular"
    
    public func displayName(includeType: Bool = true) -> String {
        switch deviceIdentifier() {
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
            }
        case let device:
            if let range = device.range(of: "iPhone") {
                return iPhoneDisplayName(model: device.substring(from: range.upperBound), includeType: includeType)
            }
            if let range = device.range(of: "iPod") {
                return iPodTouchDisplayName(model: device.substring(from: range.upperBound))
            }
            if let range = device.range(of: "iPad") {
                return iPadDisplayName(model: device.substring(from: range.upperBound), includeType: includeType)
            }
            if let range = device.range(of: "Watch") {
                return watchDisplayName(model: device.substring(from: range.upperBound))
            }
            if let range = device.range(of: "AppleTV") {
                return appleTVDisplayName(model: device.substring(from: range.upperBound))
            }
            return device
        }
    }
    
    private func appleTVDisplayName(model: String) -> String {
        let name: String
        
        switch model {
        case "2,1":
            name = "2nd Gen"
        case "3,1", "3,2":
            name = "3rd Gen"
        case "5,3":
            name = "4th Gen"
        default:
            name = "Unknown \"\(model)\""
        }
        
        return "Apple TV \(name)"
    }
    
    private func watchDisplayName(model: String) -> String {
        let name: String
        
        switch model {
        case "1,1":
            name = "1st Gen (38 mm)"
        case "1,2":
            name = "1st Gen (42 mm)"
        case "2,6":
            name = "Series 1 (38 mm)"
        case "2,7":
            name = "Series 1 (42 mm)"
        case "2,3":
            name = "Series 2 (38 mm)"
        case "2,4":
            name = "Series 2 (42 mm)"
        default:
            name = "Unknown \"\(model)\""
        }
        
        return "Apple Watch \(name)"
    }
    
    private func iPhoneDisplayName(model: String, includeType: Bool) -> String {
        let name: String
        var type: String?
        
        switch model {
        case "1,1":
            name = "2G"
        case "1,2":
            name = "3G"
        case "2,1":
            name = "3GS"
        case "3,1":
            name = "4"
            type = UIDevice.GSM
        case "3,2":
            name = "4"
            type = "8GB"
        case "3,3":
            name = "4"
            type = UIDevice.CDMA
        case "4,1":
            name = "4S"
        case "5,1":
            name = "5"
            type = UIDevice.GSM
        case "5,2":
            name = "5"
            type = UIDevice.GSM_CMDA
        case "5,3":
            name = "5c"
            type = UIDevice.GSM
        case "5,4":
            name = "5c"
            type = UIDevice.GSM_CMDA
        case "6,1":
            name = "5s"
            type = UIDevice.GSM
        case "6,2":
            name = "5s"
            type = UIDevice.GSM_CMDA
        case "7,1":
            name = "6 Plus"
        case "7,2":
            name = "6"
        case "8,1":
            name = "6s"
        case "8,2":
            name = "6s Plus"
        case "8,4":
            name = "SE"
        case "9,1", "9,3":
            name = "7"
        case "9,2", "9,4":
            name = "7 Plus"
        default:
            name = "Unknown \"\(model)\""
        }
        
        if includeType, let type = type {
            return "iPhone \(name) \(type)"
        }
        return "iPhone \(name)"
    }
    
    private func iPodTouchDisplayName(model: String) -> String {
        let name: String
        
        switch model {
        case "1,1":
            name = "1st Gen"
        case "2,1":
            name = "2nd Gen"
        case "3,1":
            name = "3rd Gen"
        case "4,1":
            name = "4th Gen"
        case "5,1":
            name = "5th Gen"
        case "7,1":
            name = "6th Gen"
        default:
            name = "Unknown \"\(model)\""
        }
        
        return "iPod Touch \(name)"
    }
    
    private func iPadDisplayName(model: String, includeType: Bool) -> String {
        let name: String
        var type: String?
        
        switch model {
        case "1,1":
            name = "1"
        case "2,1":
            name = "2"
            type = UIDevice.WiFi
        case "2,2":
            name = "2"
            type = UIDevice.GSM
        case "2,3":
            name = "2"
            type = UIDevice.CDMA
        case "2,4":
            name = "2"
            type = UIDevice.WiFi
        case "2,5":
            name = "Mini"
            type = UIDevice.WiFi
        case "2,6":
            name = "Mini"
            type = UIDevice.GSM
        case "2,7":
            name = "Mini"
            type = UIDevice.CDMA
        case "3,1":
            name = "3"
            type = UIDevice.WiFi
        case "3,2":
            name = "3"
            type = UIDevice.GSM
        case "3,3":
            name = "3"
            type = UIDevice.CDMA
        case "3,4":
            name = "4"
            type = UIDevice.WiFi
        case "3,5":
            name = "4"
            type = UIDevice.GSM
        case "3,6":
            name = "4"
            type = UIDevice.GSM_CMDA
        case "4,1":
            name = "Air"
            type = UIDevice.WiFi
        case "4,2":
            name = "Air"
            type = UIDevice.Cellular
        case "4,3":
            name = "Air"
            type = "China"
        case "4,4":
            name = "Mini 2"
            type = UIDevice.WiFi
        case "4,5":
            name = "Mini 2"
            type = UIDevice.Cellular
        case "4,6":
            name = "Mini 2"
            type = "\(UIDevice.Cellular), China"
        case "4,7":
            name = "Mini 3"
            type = UIDevice.WiFi
        case "4,8":
            name = "Mini 3"
            type = UIDevice.Cellular
        case "4,9":
            name = "Mini 3"
            type = "\(UIDevice.Cellular), China"
        case "5,1":
            name = "Mini 4"
            type = UIDevice.WiFi
        case "5,2":
            name = "Mini 4"
            type = UIDevice.Cellular
        case "5,3":
            name = "Air 2"
            type = UIDevice.WiFi
        case "5,4":
            name = "Air 2"
            type = UIDevice.Cellular
        case "6,3":
            name = "Pro (9.7 inch)"
            type = UIDevice.WiFi
        case "6,4":
            name = "Pro (9.7 inch)"
            type = UIDevice.Cellular
        case "6,7":
            name = "Pro (12.9 inch)"
            type = UIDevice.WiFi
        case "6,8":
            name = "Pro (12.9 inch)"
            type = UIDevice.Cellular
        case "6,11":
            name = "5"
            type = UIDevice.WiFi
        case "6,12":
            name = "5"
            type = UIDevice.Cellular
		case "7,1":
			name = "Pro (12.9 inch, 2nd Gen)"
            type = UIDevice.WiFi
		case "7,2":
			name = "Pro (12.9 inch, 2nd Gen)"
            type = UIDevice.Cellular
		case "7,3":
			name = "Pro (10.5 inch)"
            type = UIDevice.WiFi
		case "7,4":
			name = "Pro (10.5 inch)"
            type = UIDevice.Cellular
		default:
            name = "Unknown \"\(model)\""
        }
        
        if includeType, let type = type {
            return "iPad \(name) \(type)"
        }
        return "iPad \(name)"
    }
    
    private func deviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
}
