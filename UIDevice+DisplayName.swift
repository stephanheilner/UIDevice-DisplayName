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
    
    public func displayName(includeType includeType: Bool = true) -> String {
        switch deviceIdentifier() {
        case let simulator where simulator.hasPrefix("x86"):
            switch userInterfaceIdiom {
            case .Unspecified:
                return "Unspecified Simulator"
            case .Phone:
                return "iPhone Simulator"
            case .Pad:
                return "iPad Simulator"
            case .TV:
                return "Apple TV Simulator"
            case .CarPlay:
                return "CarPlay Simulator"
            }
        case let device:
            if let range = device.rangeOfString("iPhone") {
                return iPhoneDisplayName(device.substringFromIndex(range.endIndex), includeType: includeType)
            }
            if let range = device.rangeOfString("iPod") {
                return iPodTouchDisplayName(device.substringFromIndex(range.endIndex))
            }
            if let range = device.rangeOfString("iPad") {
                return iPadDisplayName(device.substringFromIndex(range.endIndex), includeType: includeType)
            }
            if let range = device.rangeOfString("Watch") {
                return watchDisplayName(device.substringFromIndex(range.endIndex))
            }
            if let range = device.rangeOfString("AppleTV") {
                return appleTVDisplayName(device.substringFromIndex(range.endIndex))
            }
            return device
        default:
            break
        }
        
        return "Unknown"
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
            name = "Unknown"
        }
        
        return "Apple TV \(name)"
    }
    
    private func watchDisplayName(model: String) -> String {
        let name: String
        
        switch model {
        case "1,1":
            name = "38 mm"
        case "1,2":
            name = "42 mm"
        default:
            name = "Unknown"
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
            type = "GSM"
        case "3,2":
            name = "4"
            type = "8GB"
        case "3,3":
            name = "4"
            type = "CDMA"
        case "4,1":
            name = "4S"
        case "5,1":
            name = "5"
            type = "GSM"
        case "5,2":
            name = "5"
            type = "GSM+CDMA"
        case "5,3":
            name = "5c"
            type = "GSM"
        case "5,4":
            name = "5c"
            type = "GSM+CDMA"
        case "6,1":
            name = "5s"
            type = "GSM"
        case "6,2":
            name = "5s"
            type = "GSM+CDMA"
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
        default:
            name = "Unknown"
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
            name = "Unknown"
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
            type = "Wi-Fi"
        case "2,2":
            name = "2"
            type = "GSM"
        case "2,3":
            name = "2"
            type = "CDMA"
        case "2,4":
            name = "2"
            type = "New"
        case "2,5":
            name = "Mini"
            type = "Wi-Fi"
        case "2,6":
            name = "Mini"
            type = "GSM"
        case "2,7":
            name = "Mini"
            type = "CDMA"
        case "3,1":
            name = "3"
            type = "Wi-Fi"
        case "3,2":
            name = "3"
            type = "GSM"
        case "3,3":
            name = "3"
            type = "CDMA"
        case "3,4":
            name = "4"
            type = "Wi-Fi"
        case "3,5":
            name = "4"
            type = "GSM"
        case "3,6":
            name = "4"
            type = "GSM+CDMA"
        case "4,1":
            name = "Air"
            type = "Wi-Fi"
        case "4,2":
            name = "Air"
            type = "Cellular"
        case "4,3":
            name = "Air"
            type = "China"
        case "4,4":
            name = "Mini 2"
            type = "Wi-Fi"
        case "4,5":
            name = "Mini 2"
            type = "Cellular"
        case "4,6":
            name = "Mini 2"
            type = "Cellular, China"
        case "4,7":
            name = "Mini 3"
            type = "Wi-Fi"
        case "4,8":
            name = "Mini 3"
            type = "Cellular"
        case "4,9":
            name = "Mini 3"
            type = "Cellular, China"
        case "5,1":
            name = "Mini 4"
            type = "Wi-Fi"
        case "5,2":
            name = "Mini 4"
            type = "Cellular"
        case "5,3":
            name = "Air 2"
            type = "Wi-Fi"
        case "5,4":
            name = "Air 2"
            type = "Cellular"
        case "6,3":
            name = "Pro (9.7 inch)"
            type = "Wi-Fi"
        case "6,4":
            name = "Pro (9.7 inch)"
            type = "Cellular"
        case "6,7":
            name = "Pro (12.9 inch)"
            type = "Wi-Fi"
        case "6,8":
            name = "Pro (12.9 inch)"
            type = "Cellular"
        default:
            name = "Unknown"
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
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
}
