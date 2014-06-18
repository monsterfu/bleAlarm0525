//
//  newDeviceTableViewCell.m
//  bleAlarm
//
//  Created by Monster on 14-4-30.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "newDeviceTableViewCell.h"

@implementation newDeviceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButtonTouch:(UIButton *)sender {
    
}
@end
