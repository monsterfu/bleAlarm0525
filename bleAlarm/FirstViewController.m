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
@synthesize singell1ImgView,singelr5ImgView,singelr4ImgView,singelr3ImgView,singelr2ImgView,singelr1ImgView,singell5ImgView,singell4ImgView,singell3ImgView,singell2ImgView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    rImgArray = [NSArray arrayWithObjects:singelr1ImgView,singelr2ImgView,singelr3ImgView,singelr4ImgView,singelr5ImgView,nil];
    lImgArray = [NSArray arrayWithObjects:singell1ImgView,singell2ImgView,singell3ImgView,singell4ImgView,singell5ImgView, nil];
    
    [[ConnectionManager sharedInstance]setDelegate:self];
    
    searchAnimationTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(searchAnimation) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:searchAnimationTimer forMode:NSDefaultRunLoopMode];
    
    _devicesArray = [NSMutableArray array];
    
    addedDeviceArray = [ConnectionManager sharedInstance].addedDeviceArray;
    newDeviceArray = [ConnectionManager sharedInstance].newsDeviceArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[ConnectionManager sharedInstance]setDelegate:self];
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
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"您已失去与%@的连接,正在重新连接",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [[soundVibrateManager sharedInstance]playAlertSound];
    [[soundVibrateManager sharedInstance]vibrate];  
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
    
}
- (void) didDeviceWanaFindMe:(deviceInfo*)device
{
    if (cameraVC) {
        [cameraVC takePicture];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@想要找到你",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [[soundVibrateManager sharedInstance]playAlertSound];
        [[soundVibrateManager sharedInstance]vibrate];
        
        cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:YES];
        [self presentViewController:cameraVC animated:YES completion:nil];
        
        NSTimer* takePickTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(takePictureAction) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:takePickTimer forMode:NSDefaultRunLoopMode];
    }
    
}
#pragma mark - action
- (IBAction)searchButtonTouched:(UIButton *)sender {
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
#pragma mark -cameraDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"didFinishPickingImage");
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [cameraVC dismissViewControllerAnimated:YES completion:nil];
    cameraVC = nil;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [cameraVC dismissViewControllerAnimated:YES completion:nil];
    cameraVC = nil;
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
            label.text = @"无绑定设备";
        }else{
            label.text = [NSString stringWithFormat:@"已添加设备"];
        }
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor grayColor];
        [headerView addSubview:label];
        return headerView;
    }else{
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, CELL_HEADER_HEIGHT)];
        [headerView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f]];
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

@end
