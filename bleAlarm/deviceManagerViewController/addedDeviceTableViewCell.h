//
//  addedDeviceTableViewCell.h
//  bleAlarm
//
//  Created by 符鑫 on 14-4-30.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"

@protocol addedDeviceTableViewCellDelegate <NSObject>

-(void)test;

@end


@interface addedDeviceTableViewCell : UITableViewCell<deviceInfoDelegate>

@property (nonatomic,assign)id<addedDeviceTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bleConnectImage;

@property (strong, nonatomic) deviceInfo *devInfo;

- (IBAction)switchChanged:(UISwitch *)sender;

-(void)setDevInfo:(deviceInfo *)newDevInfo;
@end
