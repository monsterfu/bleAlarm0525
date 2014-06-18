//
//  deviceDisconnectInfo.h
//  bleAlarm
//
//  Created by Monster on 14-5-22.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface deviceDisconnectInfo : NSObject

@property(nonatomic,assign)CLLocationCoordinate2D locationCoordinate2D;
@property(nonatomic,retain)NSDate* date;

+(deviceDisconnectInfo*)shareInstanceWithLocation:(CLLocation*)loca date:(NSDate*)dat;
@end
