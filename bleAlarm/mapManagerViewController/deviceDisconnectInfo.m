//
//  deviceDisconnectInfo.m
//  bleAlarm
//
//  Created by Monster on 14-5-22.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "deviceDisconnectInfo.h"

@implementation deviceDisconnectInfo

#define DATE_VALUE_KEY  @"DateValue"
#define LATITUDE_VALUE_KEY  @"latitude"
#define LONGITUDE_VALUE_KEY  @"longitude"

+(deviceDisconnectInfo*)shareInstanceWithLocation:(CLLocation*)loca date:(NSDate*)dat
{
    deviceDisconnectInfo* disconnectInfo = [[deviceDisconnectInfo alloc]init];
    disconnectInfo.locationCoordinate2D = loca.coordinate;
    disconnectInfo.date = dat;
    return disconnectInfo;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:_locationCoordinate2D.latitude forKey:LATITUDE_VALUE_KEY];
    [aCoder encodeDouble:_locationCoordinate2D.longitude forKey:LONGITUDE_VALUE_KEY];
    [aCoder encodeObject:_date forKey:DATE_VALUE_KEY];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        _locationCoordinate2D = CLLocationCoordinate2DMake([aDecoder decodeDoubleForKey:LATITUDE_VALUE_KEY], [aDecoder decodeDoubleForKey:LONGITUDE_VALUE_KEY]);
        _date  = [aDecoder decodeObjectForKey:DATE_VALUE_KEY];
    }
    return self;
}
@end
