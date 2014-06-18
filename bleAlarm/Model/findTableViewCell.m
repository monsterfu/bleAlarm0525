//
//  findTableViewCell.m
//  bleAlarm
//
//  Created by 符鑫 on 14-4-20.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "findTableViewCell.h"

@implementation findTableViewCell

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

- (IBAction)addButtonTouched:(UIButton *)sender {
    NSLog(@"addButtonTouched");
    if (sender.selected) {
        [sender setSelected:NO];
    }else{
        [USER_DEFAULT setObject:_info.identifier  forKey:KEY_DEVICE_INFO];
        [sender setSelected:YES];
    }
}

-(void)setInfo:(deviceInfo *)info
{
    _info = info;
    _label.text = info.idString;
}
@end
