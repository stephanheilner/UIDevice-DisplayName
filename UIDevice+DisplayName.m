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

#import "UIDevice+DisplayName.h"
#include <sys/sysctl.h>

@implementation UIDevice (DisplayName)

- (NSString *)displayName {
    NSString *device = [self device];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.decimalSeparator = @",";
    
    if ([device hasPrefix:@"iPhone"]) {
        NSString *model = [device substringFromIndex:[@"iPhone" length]];
        return [self iPhoneModel:[numberFormatter numberFromString:model]];
        
    } else if ([device hasPrefix:@"iPad"]) {
        NSString *model = [device substringFromIndex:[@"iPad" length]];
        return [self iPadModel:[numberFormatter numberFromString:model]];
        
    } else if ([device hasPrefix:@"iPod"]) {
        NSString *model = [device substringFromIndex:[@"iPod" length]];
        return [self iPodModel:[numberFormatter numberFromString:model]];
    }

    return [NSString stringWithFormat:@"%@ %@", [self localizedModel], [self systemVersion]];
}

- (NSString *)device {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *device = @(machine);
    free(machine);

    return device;
}

- (NSString *)iPodModel:(NSNumber *)modelNumber {
    NSInteger intModelNumber = (NSInteger)([modelNumber floatValue] * 10);
    
    NSString *modelName;
    
    switch (intModelNumber) {
        case 11:
            modelName = @"1st Gen";
            break;
        case 21:
            modelName = @"2nd Gen";
            break;
        case 31:
            modelName = @"3rd Gen";
            break;
        case 41:
            modelName = @"4th Gen";
            break;
        case 51:
            modelName = @"5th Gen";
            break;
        default:
            modelName = @"Unknown";
            break;
    }

    return [NSString stringWithFormat:@"iPod Touch %@", modelName];
}

- (NSString *)iPadModel:(NSNumber *)modelNumber {
    NSInteger intModelNumber = (NSInteger)([modelNumber floatValue] * 10);
    
    NSString *modelName;
    
    switch (intModelNumber) {
        case 11:
            modelName = @"1";
            break;
        case 21:
            modelName = @"2 Wi-Fi";
            break;
        case 22:
            modelName = @"2 GSM";
            break;
        case 23:
            modelName = @"2 CDMA";
            break;
        case 24:
            modelName = @"2 New";
            break;
        case 25:
            modelName = @"Mini Wi-Fi";
            break;
        case 26:
            modelName = @"Mini GSM";
            break;
        case 27:
            modelName = @"Mini CDMA";
            break;
        case 31:
            modelName = @"3 Wi-Fi";
            break;
        case 32:
            modelName = @"3 GSM";
            break;
        case 33:
            modelName = @"3 CDMA";
            break;
        case 34:
            modelName = @"4 Wi-Fi";
            break;
        case 35:
            modelName = @"4 GSM";
            break;
        case 36:
            modelName = @"4 GSM+CDMA";
            break;
        case 41:
            modelName = @"Air Wi-Fi";
            break;
        case 42:
            modelName = @"Air Cellular";
            break;
        case 44:
            modelName = @"Mini 2 Wi-Fi";
            break;
        case 45:
            modelName = @"Mini 2 Cellular";
            break;
        default:
            modelName = @"Unknown";
            break;
    }
    
    return [NSString stringWithFormat:@"iPad %@", modelName];
}

- (NSString *)iPhoneModel:(NSNumber *)modelNumber {
    NSInteger intModelNumber = (NSInteger)([modelNumber floatValue] * 10);
    
    NSString *modelName;

    switch (intModelNumber) {
        case 11:
            modelName = @"2G";
            break;
        case 12:
            modelName = @"3G";
            break;
        case 21:
            modelName = @"3GS";
            break;
        case 31:
            modelName = @"4 GSM";
            break;
        case 32:
            modelName = @"4 8GB";
            break;
        case 33:
            modelName = @"4 CDMA";
            break;
        case 41:
            modelName = @"4S";
            break;
        case 51:
            modelName = @"5 GSM";
            break;
        case 52:
            modelName = @"5 GSM+CDMA";
            break;
        case 53:
            modelName = @"5c GSM";
            break;
        case 54:
            modelName = @"5c GSM+CDMA";
            break;
        case 61:
            modelName = @"5s GSM";
            break;
        case 62:
            modelName = @"5s GSM+CDMA";
            break;
        default:
            modelName = @"Unknown";
            break;
    }
    
    return [NSString stringWithFormat:@"iPhone %@", modelName];
}

@end
