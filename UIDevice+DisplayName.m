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
    return [self deviceDisplayNameConcise:NO];
}

- (NSString *)conciseDisplayName {
    return [self deviceDisplayNameConcise:YES];
}

- (NSString *)deviceDisplayNameConcise:(BOOL)concise {
    NSString *device = [self device];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.decimalSeparator = @",";

    if ([device hasPrefix:@"iPhone"]) {
        NSString *model = [device substringFromIndex:[@"iPhone" length]];
        return [self iPhoneModel:[numberFormatter numberFromString:model] concise:concise];

    } else if ([device hasPrefix:@"iPad"]) {
        NSString *model = [device substringFromIndex:[@"iPad" length] concise:concise];
        return [self iPadModel:[numberFormatter numberFromString:model]];

    } else if ([device hasPrefix:@"iPod"]) {
        NSString *model = [device substringFromIndex:[@"iPod" length]];
        return [self iPodModel:[numberFormatter numberFromString:model]];

    } else if ([device hasSuffix:@"86"] || [device isEqual:@"x86_64"]) {
        BOOL isPhoneSimulator = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
        return isPhoneSimulator ? @"iPhone Simulator" : @"iPad Simulator";
    };

    return [self localizedModel];
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

- (NSString *)iPadModel:(NSNumber *)modelNumber concise:(BOOL)concise {
    NSInteger intModelNumber = (NSInteger)([modelNumber floatValue] * 10);

    NSString *modelName;
    NSString *extraInfo;

    switch (intModelNumber) {
        case 11:
            modelName = @"1";
            extraInfo = @"";
            break;
        case 21:
            modelName = @"2";
            extraInfo = @" Wi-Fi";
            break;
        case 22:
            modelName = @"2";
            extraInfo = @" GSM";
            break;
        case 23:
            modelName = @"2";
            extraInfo = @" CDMA";
            break;
        case 24:
            modelName = @"2";
            extraInfo = @" New";
            break;
        case 25:
            modelName = @"Mini";
            extraInfo = @" Wi-Fi";
            break;
        case 26:
            modelName = @"Mini";
            extraInfo = @" GSM";
            break;
        case 27:
            modelName = @"Mini";
            extraInfo = @" CDMA";
            break;
        case 31:
            modelName = @"3";
            extraInfo = @" Wi-Fi";
            break;
        case 32:
            modelName = @"3";
            extraInfo = @" GSM";
            break;
        case 33:
            modelName = @"3";
            extraInfo = @" CDMA";
            break;
        case 34:
            modelName = @"4";
            extraInfo = @" Wi-Fi";
            break;
        case 35:
            modelName = @"4";
            extraInfo = @" GSM";
            break;
        case 36:
            modelName = @"4";
            extraInfo = @" GSM+CDMA";
            break;
        case 41:
            modelName = @"Air";
            extraInfo = @" Wi-Fi";
            break;
        case 42:
            modelName = @"Air";
            extraInfo = @" Cellular";
            break;
        case 44:
            modelName = @"Mini 2";
            extraInfo = @" Wi-Fi";
            break;
        case 45:
            modelName = @"Mini 2";
            extraInfo = @" Cellular";
            break;
        case 46:
            modelName = @"Mini 2";
            extraInfo = @" China";
            break;
        case 46:
            modelName = @"Mini 2 China";
            break;
        default:
            modelName = @"Unknown";
            extraInfo = @"";
            break;
    }

    return [NSString stringWithFormat:@"iPad %@%@", modelName, concise ? @"" : extraInfo];
}

- (NSString *)iPhoneModel:(NSNumber *)modelNumber {
    NSInteger intModelNumber = (NSInteger)([modelNumber floatValue] * 10);

    NSString *modelName;
    NSString *extraInfo;

    switch (intModelNumber) {
        case 11:
            modelName = @"2G";
            extraInfo = @"";
            break;
        case 12:
            modelName = @"3G";
            extraInfo = @"";
            break;
        case 21:
            modelName = @"3GS";
            extraInfo = @"";
            break;
        case 31:
            modelName = @"4";
            extraInfo = @" GSM";
            break;
        case 32:
            modelName = @"4";
            extraInfo = @" 8GB";
            break;
        case 33:
            modelName = @"4";
            extraInfo = @" CDMA";
            break;
        case 41:
            modelName = @"4S";
            extraInfo = @"";
            break;
        case 51:
            modelName = @"5";
            extraInfo = @" GSM";
            break;
        case 52:
            modelName = @"5";
            extraInfo = @" GSM+CDMA";
            break;
        case 53:
            modelName = @"5c";
            extraInfo = @" GSM";
            break;
        case 54:
            modelName = @"5c";
            extraInfo = @" GSM+CDMA";
            break;
        case 61:
            modelName = @"5s";
            extraInfo = @" GSM";
            break;
        case 62:
            modelName = @"5s";
            extraInfo = @" GSM+CDMA";
            break;
        case 71:
            modelName = @"6 Plus";
            extraInfo = @"";
            break;
        case 72:
            modelName = @"6";
            extraInfo = @"";
            break;
        case 71:
            modelName = @"6 Plus";
            break;
        case 72:
            modelName = @"6";
            break;
        default:
            modelName = @"Unknown";
            extraInfo = @"";
            break;
    }

    return [NSString stringWithFormat:@"iPhone %@%@", modelName, concise ? @"" : extraInfo];
}

@end
