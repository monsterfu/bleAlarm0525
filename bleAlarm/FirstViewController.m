//
//  FirstViewController.m
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

#define CELL_HEADER_HEIGHT   (30)
#define CELL_ROW_HEIGHT   (48)

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [[ConnectionManager sharedInstance]setDelegate:self];
    
    _devicesArray = [NSMutableArray array];
    
    addedDeviceArray = [ConnectionManager sharedInstance].addedDeviceArray;
    newDeviceArray = [ConnectionManager sharedInstance].newsDeviceArray;
    
    _searchOpen = NO;
    _ldAnimationIndex = 0;
    // 读取gif图片数据
//    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"leida@2x" ofType:@"gif"]];
//    // view生成
//    
//    _gifWebView.userInteractionEnabled = NO;//用户不可交互
//    [_gifWebView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    _ldTimer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(leidaAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_ldTimer forMode:NSRunLoopCommonModes];
    
}
-(void)leidaAnimation
{
    if (_ldAnimationIndex < 9) {
        _ldAnimationIndex ++;
    }else{
        _ldAnimationIndex = 0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [_animImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",_ldAnimationIndex+1]]];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[ConnectionManager sharedInstance]setDelegate:self];
    [_tableView reloadData];
}
static NSUInteger searchInd = 0;
-(void)searchAnimation
{
    if (searchInd == 0) {
        searchInd ++;
        
        for (UIImageView* img in rImgArray) {
            [img setHidden:YES];
        }
        for (UIImageView* img in lImgArray) {
            [img setHidden:YES];
        }
    
    }else if(searchInd == 6){
        searchInd = 0;
    }else{
        [[rImgArray objectAtIndex:searchInd -1] setHidden:NO];
        [[lImgArray objectAtIndex:searchInd -1] setHidden:NO];
        searchInd ++;
    }
    
}
#pragma mark - connectionManagerDelegate
- (void) isBluetoothEnabled:(bool) enabled
{
    if (enabled == YES) {
        [[ConnectionManager sharedInstance] startScanForDevice];
    }
}

- (void) didDiscoverDevice:(deviceInfo*)device
{
    addedDeviceArray = [ConnectionManager sharedInstance].addedDeviceArray;
    newDeviceArray = [ConnectionManager sharedInstance].newsDeviceArray;

    [self.tableView reloadData];
}

- (void) didDisconnectWithDevice:(deviceInfo*)device
{
    addedDeviceArray = [ConnectionManager sharedInstance].addedDeviceArray;
    newDeviceArray = [ConnectionManager sharedInstance].newsDeviceArray;
    
    [self.tableView reloadData];
}
- (void) didConnectWithDevice:(deviceInfo*)device
{
    if (!device) {
        return;
    }
    addedDeviceArray = [ConnectionManager sharedInstance].addedDeviceArray;
    newDeviceArray = [ConnectionManager sharedInstance].newsDeviceArray;
    
    [self.tableView reloadData];
}
- (void) didOutofRangWithDevice:(deviceInfo*)device
{
    return;
    UIAlertView* _alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"已超出设定范围", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil)  otherButtonTitles:nil, nil];
    [_alertView show];
    [[soundVibrateManager sharedInstance]playAlertSound];
    [[soundVibrateManager sharedInstance]vibrate];
}


- (void) didDeviceWanaFindMe:(deviceInfo*)device
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"想要找到你", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
    [alert show];
    [[soundVibrateManager sharedInstance]playAlertSound];
    [[soundVibrateManager sharedInstance]vibrate];
}
#pragma mark - action
- (IBAction)searchButtonTouched:(UIButton *)sender {
    if (!_searchOpen) {
        _searchOpen = YES;
        
        searchInd = 0;
        searchAnimationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(searchAnimation) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop]addTimer:searchAnimationTimer forMode:NSDefaultRunLoopMode];
       
    }else{
        _searchOpen = NO;
        [searchAnimationTimer invalidate];
        searchAnimationTimer = nil;
        for (UIImageView* img in rImgArray) {
            [img setHidden:YES];
        }
        for (UIImageView* img in lImgArray) {
            [img setHidden:YES];
        }
    }
     [_tableView reloadData];
}

- (IBAction)cameraButtonTouch:(UIBarButtonItem *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:YES];
        [self presentViewController:cameraVC animated:YES completion:nil];
    }
}
-(void)takePictureAction
{
    if (cameraVC) {
        [cameraVC takePicture];
    }
}

#pragma mark - viewControlsegement

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"deviceConnect"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        deviceInfo *device = [addedDeviceArray objectAtIndex:[indexPath row]];
        
        SecondViewController * secondViewController = (SecondViewController *)segue.destinationViewController;
        secondViewController.devInfo = device;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_ROW_HEIGHT;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CELL_HEADER_HEIGHT)];
        [headerView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f]];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 260, CELL_HEADER_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        if ([addedDeviceArray count] == 0) {
            label.text = NSLocalizedString(@"无绑定设备",nil);
        }else{
            label.text = [NSString stringWithFormat:NSLocalizedString(@"已添加设备",nil)];
        }
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        [headerView addSubview:label];
        return headerView;
    }else{
        UIImageView* headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iseek3_02"]];
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
        deviceInfo* device = [addedDeviceArray objectAtIndex:indexPath.row];
        if (device.connected) {
            [self performSegueWithIdentifier:@"deviceConnect" sender:nil];
        }
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
        if (indexPath.section == 0) {
            [[ConnectionManager sharedInstance]removeDevice:[addedDeviceArray objectAtIndex:indexPath.row]];
            [addedDeviceArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
            NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:addedDeviceArray];
            [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
            [USER_DEFAULT synchronize];
        }else{
            [[ConnectionManager sharedInstance]removeDevice:[newDeviceArray objectAtIndex:indexPath.row]];
            [newDeviceArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
#pragma mark - cellDelegate

-(void)updateCellInfo:(deviceInfo*)device
{
    
}
@end
