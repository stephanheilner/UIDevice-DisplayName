# UIDevice-DisplayName

`displayName()`
Returns a friendly name for an iOS device, leaving out the specific type information (i.e. "iPhone X")


`displayName(includeType: true)`
Returns a friendly name for an iOS device, which also includes the device type (i.e. "iPhone X (GSM)")

## License

UIDevice-DisplayName is available under the MIT license. See the LICENSE file for more info.

## Usage

```swift
NSLog("Device Display Name: %@", UIDevice.current.displayName())

NSLog("Device Display Name With Type: %@", UIDevice.current.displayName(includeType: true))
```
