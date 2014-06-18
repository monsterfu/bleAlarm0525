//
//  newDeviceTableViewCell.h
//  bleAlarm
//
//  Created by Monster on 14-4-30.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol newDeviceTableViewCellDelegate <NSObject>

-(void)test;

@end


@interface newDeviceTableViewCell : UITableViewCell

@property(nonatomic,assign)id<newDeviceTableViewCellDelegate>delegate;
- (IBAction)addButtonTouch:(UIButton *)sender;

@end
