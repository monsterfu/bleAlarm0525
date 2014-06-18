//
//  deviceManagerTableViewController.m
//  bleAlarm
//
//  Created by 符鑫 on 14-4-29.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "deviceManagerTableViewController.h"

@interface deviceManagerTableViewController ()

@end
#define CELL_HEADER_HEIGHT   (30)
@implementation deviceManagerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
   
    addedDeviceArray = [ConnectionManager sharedInstance].addedDeviceArray;
    newDeviceArray = [ConnectionManager sharedInstance].newsDeviceArray;
    
//    for (id obj in [ConnectionManager sharedInstance].peripheralDictionary) {
//        CBPeripheral* peripherals = (CBPeripheral*)obj;
//        NSLog(@"peripherals.name:%@,peripherals.identifier:%@",peripherals.name,peripherals.identifier);
//        [addedDeviceArray addObject:[deviceInfo deviceWithId:peripherals.name identifier:[peripherals.identifier UUIDString]]];
//    }
    
//    
//    NSData* aData = [USER_DEFAULT objectForKey:KEY_DEVICELIST_INFO];
//    addedDeviceArray = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
//    if (addedDeviceArray == nil) {
//        addedDeviceArray = [NSMutableArray array];
//    }
//    newDeviceArray = [NSMutableArray array];
}
-(void)viewDidAppear:(BOOL)animated
{
    [[ConnectionManager sharedInstance]setDelegate:self];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ble
- (void) isBluetoothEnabled:(bool) enabled
{
    if (enabled) {
        [[ConnectionManager sharedInstance] startScanForDevice];
    }
}
- (void) didDiscoverDevice:(deviceInfo*)device
{
    for (deviceInfo* deviceStore in addedDeviceArray) {
        if ([deviceStore.idString isEqualToString:device.idString]) {
            _devInfo = device;
            _devInfo.delegate = self;
            return;
        }
    }
    
    for (deviceInfo* deviceStore in newDeviceArray) {
        if ([deviceStore.idString isEqualToString:device.idString]) {
            return;
        }
    }
    
    [newDeviceArray addObject:device];
    [self.tableView reloadData];
    
}
- (void) didDisconnectWithDevice:(NSString*)device
{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"您已失去与%@的连接",device] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - Device data update

-(void)didUpdateData:(deviceInfo*)info
{
//    NSLog(@"signalStrength:%f",[info.signalStrength floatValue]);
//    _singalImageView.image = [info currentSignalStrengthImage];
//    _batteryImageView.image = [info currentBatteryStrengthImage];
//    CGFloat meter = (-1)*[info.signalStrength floatValue];
//    
//    if (meter < 30.0f) {
//        meter = 31.0f;
//    }else if(meter > _numDistance)
//    {
//        [[soundVibrateManager sharedInstance]playAlertSound];
//        [[soundVibrateManager sharedInstance]vibrate];
//    }
//    
//    if (meter > 70.0f) {
//        meter = 69.0f;
//    }
//    
//    NSUInteger distance = ((meter -30)/40)*(_radarImagView.frame.size.width/2);
//    [_searchView setMeterInt:distance];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [addedDeviceArray count];
    }else{
        return [newDeviceArray count];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([addedDeviceArray count] == 0) {
            return @"无绑定设备";
        }else
        return @"已绑定设备";
    }else{
        return @"正在搜索";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CELL_HEADER_HEIGHT;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CELL_HEADER_HEIGHT)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 260, CELL_HEADER_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        if ([addedDeviceArray count] == 0) {
            label.text = @"无绑定设备";
        }else{
            label.text = [NSString stringWithFormat:@"%lu台绑定设备",[addedDeviceArray count]];
        }
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        [headerView addSubview:label];
        return headerView;
    }else{
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CELL_HEADER_HEIGHT)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 260, CELL_HEADER_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"正在搜索…";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        [headerView addSubview:label];
        
        UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView setFrame:CGRectMake(200, 5, 20, 20)];
        [headerView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        return headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        addedCell = [tableView dequeueReusableCellWithIdentifier:@"addedDeviceCell" forIndexPath:indexPath];
        addedCell.delegate = self;
        [addedCell setDevInfo:[addedDeviceArray objectAtIndex:indexPath.row]];
        return addedCell;
    }else{
        newCell = [tableView dequeueReusableCellWithIdentifier:@"newDeviceCell" forIndexPath:indexPath];
        _devInfo = [newDeviceArray objectAtIndex:indexPath.row];
        newCell.textLabel.text = _devInfo.idString;
        newCell.delegate = self;
        return newCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        deviceInfo* devIn = (deviceInfo*)[addedDeviceArray objectAtIndex:indexPath.row];
        [USER_DEFAULT setObject:devIn.identifier forKey:KEY_DEVICE_INFO];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [addedDeviceArray addObject:[newDeviceArray objectAtIndex:indexPath.row]];
        [newDeviceArray removeObjectAtIndex:indexPath.row];
        
        [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
        NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:addedDeviceArray];
        [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
        [USER_DEFAULT synchronize];
        
        [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:1] toIndexPath:[NSIndexPath indexPathForRow:[addedDeviceArray count]-1 inSection:0]];
        [self.tableView reloadData];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [addedDeviceArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
