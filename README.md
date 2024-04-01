# UIDevice-DisplayName

`displayName()`
Returns a friendly name for an iOS device, leaving out the specific type information (i.e. "iPhone X")


`displayName(includeType: true)`
Returns a friendly name for an iOS device, which also includes the device type (i.e. "iPhone X (GSM)")

## License

UIDevice-DisplayName is available under the MIT license. See the LICENSE file for more info.


## Privacy Manifest

* This package collects & reports the name of the device model. It does not collect the device id or any user-specific data.

## Usage

```swift
NSLog("Device Display Name: %@", UIDevice.current.displayName())

NSLog("Device Display Name With Type: %@", UIDevice.current.displayName(includeType: true))
```
