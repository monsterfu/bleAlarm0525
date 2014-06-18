//
//  findTableViewCell.h
//  bleAlarm
//
//  Created by 符鑫 on 14-4-20.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalHeader.h"

@interface findTableViewCell : UITableViewCell

@property(nonatomic, retain)deviceInfo* info;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)addButtonTouched:(UIButton *)sender;
@end
