//
//  NSString+deviceName.h
//  bleAlarm
//
//  Created by Monster on 14-7-11.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "deviceInfo.h"
#import "GlobalHeader.h"

@interface NSString (deviceName)

+(NSString*)deviceNameWithDevice:(deviceInfo*)device;
@end
