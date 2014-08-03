//
//  dimissDetailTableViewController.h
//  bleAlarm
//
//  Created by 符鑫 on 14-8-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import "mapViewController.h"

@interface dimissDetailTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) deviceInfo *devInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)backButtonTouch:(UIButton *)sender;



@end
