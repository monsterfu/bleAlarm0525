//
//  recordAnnotation.m
//  bleAlarm
//
//  Created by Monster on 14-5-22.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "recordAnnotation.h"

@implementation recordAnnotation
@synthesize coordinate, title, subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init]) {
        coordinate = coords;
    }
    return self;
}
@end
