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
    [self.delegate updateCellInfo:_devInfo tag:self.tag];
}

-(void)setDevInfo:(deviceInfo *)newDevInfo
{
    self.deviceLabel.text = [NSString deviceNameWithDevice:newDevInfo];
    self.deviceLabel.textColor = [UIColor getColor:@"8DDBFF"];
    _signalImageView.image = [newDevInfo currentSignalStrengthImage];
    _devInfo = newDevInfo;
    if (newDevInfo.connected) {
        [_bleConnectImage setImage:[UIImage imageNamed:@"iseek3_08"]];
    }else{
        [_bleConnectImage setImage:[UIImage imageNamed:@"iseek3_24"]];
    }
    
    [_customSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    //self.view.backgroundColor = [UIColor colorWithRed:0.19f green:0.23f blue:0.33f alpha:1.00f];
//    _customSwitch.knobColor = [UIColor colorWithRed:0.19f green:0.23f blue:0.33f alpha:1.00f];
//    _customSwitch.activeColor = [UIColor colorWithRed:0.07f green:0.09f blue:0.11f alpha:1.00f];
//    _customSwitch.inactiveColor = [UIColor colorWithRed:0.07f green:0.09f blue:0.11f alpha:1.00f];
//    _customSwitch.onColor = [UIColor colorWithRed:0.45f green:0.58f blue:0.67f alpha:1.00f];
//    _customSwitch.borderColor = [UIColor clearColor];
//    _customSwitch.shadowColor = [UIColor blueColor];
    
    [_customSwitch setOn:newDevInfo.open animated:YES];
    
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
    [self.delegate updateCellInfo:device tag:self.tag];
}

-(void)didConnectedNotice:(deviceInfo *)device{
    [self.delegate updateCellInfo:device tag:self.tag];
}
@end
