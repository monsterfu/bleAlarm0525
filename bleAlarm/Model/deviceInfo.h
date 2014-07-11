//
//  deviceInfo.h
//  bleAlarm
//
//  Created by 符鑫 on 14-4-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "locationCoordinateInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>

@class deviceInfo;

@protocol deviceInfoDelegate
-(void)didUpdateData:(deviceInfo*)info;
-(void)didConnectedNotice:(deviceInfo*)device;
-(void)didDisconnectedNotice:(deviceInfo*)device;

@end

@interface deviceInfo : NSObject
{
    NSTimer* connectNoticeTimer;
}
@property (nonatomic, retain) id<deviceInfoDelegate> delegate;
@property (nonatomic, retain) NSNumber *batteryLevel;
@property (nonatomic, retain) NSString *idString;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSNumber *signalStrength;
@property (nonatomic, retain) NSNumber *warningStrength;
@property (nonatomic, retain) NSMutableArray *locationCoordArray;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, assign) BOOL isUserForceDisconnect;//用户强制删除、断开
@property (nonatomic, retain) NSNumber *rangeLimit;

+ (CBUUID *) batteryServiceUUID;
+ (CBUUID *) thermometerServiceUUID;

+ (CBUUID *) ServiceUUIDOne;
+ (CBUUID *) ServiceUUIDTwo;
+ (CBUUID *) ServiceUUIDThree;
+ (deviceInfo *) deviceWithId:(NSString *) idString identifier:(NSString*)identifier;
- (void) setBatteryLevelWithRawData:(NSData *)rawData;

- (UIImage *) currentSignalStrengthImage;
- (UIImage *) currentBatteryStrengthImage;

-(void)addLocationCoordArray:(locationCoordinateInfo*)objects;

-(void)connectedNotice;
-(void)disconnectedNotice;
@end