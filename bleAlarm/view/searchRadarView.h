//
//  searchRadarView.h
//  bleAlarm
//
//  Created by 符鑫 on 14-4-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchRadarView : UIView

@property(nonatomic)NSUInteger meterInt;

+(searchRadarView*)stardcaseFrame:(CGRect)rect terInt:(NSUInteger)t;
@end
