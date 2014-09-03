//
//  NSNumber+exchargeRange.m
//  bleAlarm
//
//  Created by Monster on 14-7-11.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "NSNumber+exchargeRange.h"

@implementation NSNumber (exchargeRange)
//70-85   85-95  95-100 100-105
+(NSNumber*)exchargeRange:(CGFloat)value
{
    if (0 <= value&& value <= 25) {
        return [NSNumber numberWithFloat:75.0f+(15.0f/25.0f)*value];
    }else if (25 < value&& value <= 50){
        return[NSNumber numberWithFloat:85.0f+(10.0f/25.0f)*(value - 25)];
    }else if (50 < value&& value <= 75){
        return[NSNumber numberWithFloat:95.0f+(5.0f/25.0f)*(value - 50)];
    }else if (75 < value&& value <= 100){
        return[NSNumber numberWithFloat:100.0f+(5.0f/25.0f)*(value - 75)];
    }
    return nil;
}

@end
