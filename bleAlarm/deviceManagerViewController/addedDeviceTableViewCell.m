//
//  addedDeviceTableViewCell.m
//  bleAlarm
//
//  Created by 符鑫 on 14-4-30.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "addedDeviceTableViewCell.h"

@implementation addedDeviceTableViewCell

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

- (IBAction)switchChanged:(UISwitch *)sender {
    _devInfo.open = sender.on;
}

-(void)setDevInfo:(deviceInfo *)newDevInfo
{
    if ([USER_DEFAULT objectForKey:newDevInfo.identifier]) {
        self.deviceLabel.text = [USER_DEFAULT objectForKey:newDevInfo.identifier];
    }else{
        self.deviceLabel.text = newDevInfo.idString;
    }
    _signalImageView.image = [newDevInfo currentSignalStrengthImage];
    _devInfo = newDevInfo;
    if (newDevInfo.connected) {
        [_bleConnectImage setHidden:NO];
    }else{
        [_bleConnectImage setHidden:YES];
    }
    
    
    [_switchView setOn:newDevInfo.open animated:YES];
    
    _devInfo.delegate = self;
}
  //

#pragma mark - deviceinfoUpdate
-(void)didUpdateData:(deviceInfo*)info
{
    [self setDevInfo:info];
}

-(void)didDisconnectedNotice:(deviceInfo *)device
{
    [self.delegate updateCellInfo:device];
}

-(void)didConnectedNotice:(deviceInfo *)device{
    [self.delegate updateCellInfo:device];
}
@end
