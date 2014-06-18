//
//  searchRadarView.m
//  bleAlarm
//
//  Created by 符鑫 on 14-4-21.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "searchRadarView.h"

@implementation searchRadarView

+(searchRadarView*)stardcaseFrame:(CGRect)rect terInt:(NSUInteger)t
{
    searchRadarView* radarView = [[searchRadarView alloc]initWithFrame:rect terInt:t];
    return radarView;
}


- (id)initWithFrame:(CGRect)frame terInt:(NSUInteger)t
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.6f;
        _meterInt = t;
    }
    return self;
}

-(void)setMeterInt:(NSUInteger)meterInt
{
    _meterInt = meterInt;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor (context,  0, 0, 0, 1.0);
    if (_meterInt <= 10) {
        CGContextAddArc(context, self.center.x, self.center.y, 0, 0, 2*M_PI, 0);
    }else{
        CGContextAddArc(context, self.center.x, self.center.y, _meterInt-10, 0, 2*M_PI, 0);
    }
    CGContextDrawPath(context, kCGPathFill);

    CGContextSetRGBFillColor (context,  1, 1, 1, 0.5);
    CGContextAddArc(context, self.center.x, self.center.y, _meterInt, 0, 2*M_PI, 0);
    
    CGContextDrawPath(context, kCGPathFill);
}


@end
