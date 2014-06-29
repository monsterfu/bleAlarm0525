//
//  deviceInfo.m
//  bleAlarm
//
//  Created by 符鑫 on 14-4-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "deviceInfo.h"

@implementation deviceInfo

#define INT_VALUE_KEY @"int"
#define STR_VALUE_KEY @"String"
#define BOOL_VALUE_KEY @"bool"
#define IDENTIFIER_VALUE_KEY  @"identifier"
#define WARNING_VALUE_KEY  @"warningValue"
#define COORDINATE_VALUE_KEY  @"coordinateArray"

+ (CBUUID *) batteryServiceUUID
{
    return [CBUUID UUIDWithString:@"180F"];
}

+ (CBUUID *) thermometerServiceUUID
{
    return [CBUUID UUIDWithString:@"1809"];
}

+ (CBUUID *) ServiceUUIDOne
{
    return [CBUUID UUIDWithString:@"1802"];
}

+ (CBUUID *) ServiceUUIDTwo
{
    return [CBUUID UUIDWithString:@"1803"];
}

+ (CBUUID *) ServiceUUIDThree
{
    return [CBUUID UUIDWithString:@"1804"];
}


+ (deviceInfo *) deviceWithId:(NSString *) idString identifier:(NSString*)identifier
{
    deviceInfo* dev = [[deviceInfo alloc]init];
    dev.idString = idString;
    dev.locationCoordArray = [NSMutableArray array];
    dev.identifier = identifier;
    dev.connected = NO;
    dev.open = YES;
    dev.warningStrength = [NSNumber numberWithFloat:90.0f];
    return dev;
}


- (void) setBatteryLevelWithRawData:(NSData *)rawData
{
    uint8_t value;
    [rawData getBytes:&value length:1];
    self.batteryLevel = [NSNumber numberWithUnsignedShort:value];
    
    [self.delegate didUpdateData:self];
}

- (UIImage *) currentSignalStrengthImage
{
    NSString *imageName;
    if (self.signalStrength.floatValue > -44.0)
        imageName = @"signal5.png";
    else if (self.signalStrength.floatValue > -50.0)
        imageName = @"signal4.png";
    else if (self.signalStrength.floatValue > -60.0)
        imageName = @"signal3.png";
    else if (self.signalStrength.floatValue > -70.0)
        imageName = @"signal2.png";
    else
        imageName = @"signal1.png";
    return [UIImage imageNamed:imageName];
}
- (UIImage *) currentBatteryStrengthImage
{
    NSString *imageName;
    if (self.batteryLevel.floatValue < 10.0)
        imageName = @"battery6.png";
    else if (self.batteryLevel.floatValue < 30.0)
        imageName = @"battery2.png";
    else if (self.batteryLevel.floatValue < 45.0)
        imageName = @"battery3.png";
    else if (self.batteryLevel.floatValue < 60.0)
        imageName = @"battery4.png";
    else if (self.batteryLevel.floatValue < 75.0)
        imageName = @"battery5.png";
    else
        imageName = @"battery6.png";
    
    return [UIImage imageNamed:imageName];
}

-(void)addLocationCoordArray:(locationCoordinateInfo*)objects
{
    if (_locationCoordArray != nil) {
        [_locationCoordArray addObject:objects];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_idString forKey:STR_VALUE_KEY];
    [aCoder encodeBool:_open forKey:BOOL_VALUE_KEY];
    [aCoder encodeObject:_identifier forKey:IDENTIFIER_VALUE_KEY];
    [aCoder encodeObject:_warningStrength forKey:WARNING_VALUE_KEY];
    [aCoder encodeObject:_locationCoordArray forKey:COORDINATE_VALUE_KEY];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        _idString  = [aDecoder decodeObjectForKey:STR_VALUE_KEY];
        _open  = [aDecoder decodeBoolForKey:BOOL_VALUE_KEY];
        _identifier = [aDecoder decodeObjectForKey:IDENTIFIER_VALUE_KEY];
        _warningStrength = [aDecoder decodeObjectForKey:WARNING_VALUE_KEY];
        _locationCoordArray = [aDecoder decodeObjectForKey:COORDINATE_VALUE_KEY];
    }
    return self;
}

-(void)connectedNotice
{
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(didConnectedNotice)]) {
        [self.delegate didConnectedNotice:self];
    
    if (connectNoticeTimer) {
        [connectNoticeTimer invalidate];
        connectNoticeTimer = nil;
    }
}
-(void)dos
{
    [self.delegate didDisconnectedNotice:self];
}
-(void)disconnectedNotice
{
    if (connectNoticeTimer) {
        return;
    }
    connectNoticeTimer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(dos) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:connectNoticeTimer forMode:NSRunLoopCommonModes];
}
@end
