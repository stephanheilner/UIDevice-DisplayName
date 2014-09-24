# UIDevice-DisplayName

displayName
Returns a friendly name for an iOS device.

displayModelName
Returns a shorter friendly name for an iOS device by only including the device model (leaving out celluar type, i.e iPhone 5 GSM will be iPhone 5)

## License

UIDevice-DisplayName is available under the MIT license. See the LICENSE file for more info.

## Usage

```objective-c
NSLog(@"Device Display Name: %@", [[UIDevice currentDevice] displayName]);

NSLog(@"Device Display Model Name: %@", [[UIDevice currentDevice] displayModelName]);
```
