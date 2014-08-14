//
//  GlobalHeader.h
//  bleAlarm
//
//  Created by 符鑫 on 14-4-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#ifndef bleAlarm_GlobalHeader_h
#define bleAlarm_GlobalHeader_h



#import "soundVibrateManager.h"
#import"ConnectionManager.h"
#import "deviceInfo.h"

#import "UIImage+Extras.h"
#import "NSString+deviceName.h"
#import "CLLocation+YCLocation.h"
#import "NSNumber+exchargeRange.h"
#import "UIColor+getColor.h"
#import "SevenSwitch.h"

//customer used define
#define USER_DEFAULT  [NSUserDefaults standardUserDefaults]
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT  [UIScreen mainScreen].bounds.size.height
//SANDBOX KEY

#define KEY_DEVICE_INFO   @"key_device_info"

#define KEY_DEVICELIST_INFO   @"key_devicelist_info"         //设备列表


#define NSNotificationCenter_dismissRecordChange            @"NSNotificationCenter_dismissRecordChange"
#define NSNotificationCenter_appWillEnterBackGround         @"NSNotificationCenter_appWillEnterBackGround"
#define NSNotificationCenter_appWillEnterForeground         @"NSNotificationCenter_appWillEnterForeground"
#endif
