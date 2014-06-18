//
//  locationCoordinateInfo.h
//  bleAlarm
//
//  Created by Monster on 14-4-30.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface locationCoordinateInfo : NSObject

@property(nonatomic, assign)CLLocationCoordinate2D coord;
@property(nonatomic, retain)NSDate* date;
@end
