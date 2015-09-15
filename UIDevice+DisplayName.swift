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


extension UIDevice {

    static var numberFormatter: NSNumberFormatter {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.decimalSeparator = ","
        return numberFormatter
    }
    
    func displayName() -> String {
        return displayNameShowSubFamily(true)
    }
    
    func displayModelName() -> String {
        return displayNameShowSubFamily(false)
    }
    
    private func displayNameShowSubFamily(showSubFamily: Bool) -> String {
        
        switch deviceIdentifier() {
        case let device where device.hasPrefix("iPhone"):
            let model = device.substringFromIndex(device.startIndex.advancedBy("iPhone".length))
            return iPhoneModel(Float(UIDevice.numberFormatter.numberFromString(model) ?? 0), showSubFamily: showSubFamily)
        case let device where device.hasPrefix("iPad"):
            let model = device.substringFromIndex(device.startIndex.advancedBy("iPad".length))
            return iPadModel(Float(UIDevice.numberFormatter.numberFromString(model) ?? 0), showSubFamily: showSubFamily)
        case let device where device.hasPrefix("iPod"):
            let model = device.substringFromIndex(device.startIndex.advancedBy("iPod".length))
            return iPodModel(Float(UIDevice.numberFormatter.numberFromString(model) ?? 0))
        case let device where device.hasSuffix("86") || device.hasSuffix("64"):
            return UI_USER_INTERFACE_IDIOM() == .Phone ? "iPhone Simulator" : "iPad Simulator"
        default:
            break
        }
        
        return localizedModel
    }
    
    private func deviceIdentifier() -> String {
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        
        let machine = malloc(size)
        sysctlbyname("hw.machine", machine, &size, nil, 0)
        
        let identifier = String(machine)
        free(machine)
        
        return identifier
    }
    
    private func iPodModel(modelNumber: Float) -> String {
        let intModelNumber = Int(modelNumber * 10.0)
        
        let modelName: String
        
        switch intModelNumber {
        case 11:
            modelName = "1st Gen"
        case 21:
            modelName = "2nd Gen"
        case 31:
            modelName = "3rd Gen"
        case 41:
            modelName = "4th Gen"
        case 51:
            modelName = "5th Gen"
        case 61, 71:
            modelName = "6th Gen"
        default:
            modelName = "Unknown"
        }
        
        return "iPod Touch \(modelName)"
    }
    
    private func iPadModel(modelNumber: Float, showSubFamily: Bool) -> String {
        let intModelNumber = Int(modelNumber * 10.0)
        
        let modelName: String
        var subFamily = ""
        
        switch intModelNumber {
        case 11:
            modelName = "1"
        case 21:
            modelName = "2"
            subFamily = "Wi-Fi"
        case 22:
            modelName = "2"
            subFamily = "GSM"
        case 23:
            modelName = "2"
            subFamily = "CDMA"
        case 24:
            modelName = "2"
            subFamily = "New"
        case 25:
            modelName = "Mini"
            subFamily = "Wi-Fi"
        case 26:
            modelName = "Mini"
            subFamily = "GSM"
        case 27:
            modelName = "Mini"
            subFamily = "CDMA"
        case 31:
            modelName = "3"
            subFamily = "Wi-Fi"
        case 32:
            modelName = "3"
            subFamily = "GSM"
        case 33:
            modelName = "3"
            subFamily = "CDMA"
        case 34:
            modelName = "4"
            subFamily = "Wi-Fi"
        case 35:
            modelName = "4"
            subFamily = "GSM"
        case 36:
            modelName = "4"
            subFamily = "GSM+CDMA"
        case 41:
            modelName = "Air"
            subFamily = "Wi-Fi"
        case 42:
            modelName = "Air"
            subFamily = "Cellular"
        case 43:
            modelName = "Air"
            subFamily = "China"
        case 44:
            modelName = "Mini 2"
            subFamily = "Wi-Fi"
        case 45:
            modelName = "Mini 2"
            subFamily = "Cellular"
        case 46:
            modelName = "Mini 2"
            subFamily = "China"
        case 47:
            modelName = "Mini 3"
            subFamily = "Wi-Fi"
        case 48:
            modelName = "Mini 3"
            subFamily = "Cellular"
        case 49:
            modelName = "Mini 3"
            subFamily = "China"
        case 53:
            modelName = "Air 2"
            subFamily = "Wi-Fi"
        case 54:
            modelName = "Air 2"
            subFamily = "Cellular"
        default:
            modelName = "Unknown"
        }
        
        if showSubFamily && !subFamily.isEmpty {
            return "iPad \(modelName) \(subFamily)"
        }
        
        return "iPad \(modelName)"
    }
    
    private func iPhoneModel(modelNumber: Float, showSubFamily: Bool) -> String {
        let intModelNumber = Int(modelNumber * 10.0)
        
        let modelName: String
        var subFamily = ""
        
        switch intModelNumber {
        case 11:
            modelName = "2G"
        case 12:
            modelName = "3G"
        case 21:
            modelName = "3GS"
        case 31:
            modelName = "4"
            subFamily = "GSM"
        case 32:
            modelName = "4"
            subFamily = "8GB"
        case 33:
            modelName = "4"
            subFamily = "CDMA"
        case 41:
            modelName = "4S"
        case 51:
            modelName = "5"
            subFamily = "GSM"
        case 52:
            modelName = "5"
            subFamily = "GSM+CDMA"
        case 53:
            modelName = "5c"
            subFamily = "GSM"
        case 54:
            modelName = "5c"
            subFamily = "GSM+CDMA"
        case 61:
            modelName = "5s"
            subFamily = "GSM"
        case 62:
            modelName = "5s"
            subFamily = "GSM+CDMA"
        case 71:
            modelName = "6 Plus"
        case 72:
            modelName = "6"
        case 81:
            modelName = "6s Plus"
        case 82:
            modelName = "6s"
        default:
            modelName = "Unknown"
        }
        
        if showSubFamily && !subFamily.isEmpty {
            return "iPhone \(modelName) \(subFamily)"
        }
        
        return "iPhone \(modelName)"
    }
    
}
