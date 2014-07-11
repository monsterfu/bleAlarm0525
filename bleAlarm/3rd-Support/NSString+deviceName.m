//
//  NSString+deviceName.m
//  bleAlarm
//
//  Created by Monster on 14-7-11.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "NSString+deviceName.h"

@implementation NSString (deviceName)

+(NSString*)deviceNameWithDevice:(deviceInfo*)device
{
    if ([USER_DEFAULT objectForKey:device.identifier]) {
        return [USER_DEFAULT objectForKey:device.identifier];
    }else{
        return device.idString;
    }
}
@end
