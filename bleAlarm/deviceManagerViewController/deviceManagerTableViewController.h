//
//  deviceManagerTableViewController.h
//  bleAlarm
//
//  Created by 符鑫 on 14-4-29.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import "addedDeviceTableViewCell.h"
#import "newDeviceTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface deviceManagerTableViewController : UITableViewController<deviceInfoDelegate,ConnectionManagerDelegate,addedDeviceTableViewCellDelegate,newDeviceTableViewCellDelegate>
{
    NSMutableArray* addedDeviceArray;
    NSMutableArray* newDeviceArray;
    
    addedDeviceTableViewCell* addedCell;
    newDeviceTableViewCell* newCell;
}

@property (strong, nonatomic) deviceInfo *devInfo;
@end
