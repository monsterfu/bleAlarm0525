//
//  SecondViewController.m
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_slider setThumbImage:[UIImage imageNamed:@"bar dot.png"] forState:UIControlStateNormal];
    
    CGRect frame = CGRectMake(0, 0, _radarImagView.frame.size.width, _radarImagView.frame.size.height);
    _searchView = [searchRadarView stardcaseFrame:frame terInt: _radarImagView.frame.size.width/4];
    [_radarImagView addSubview:_searchView];
    
    _deviceNameLabel.text = [NSString deviceNameWithDevice:_devInfo];
    _deviceNameLabel.delegate = self;
   
    
    if (_devInfo.connected) {
        [_findButton setTitle:NSLocalizedString(@"找到我",nil) forState:UIControlStateNormal];
    }else{
        [_findButton setTitle:NSLocalizedString(@"连接",nil) forState:UIControlStateNormal];
    }
    _openl  = NO;
    _canNotice = YES;
    _canCamera = NO;
    
    _areaIndexArray = @[[NSNumber numberWithInteger:40],[NSNumber numberWithInteger:80],[NSNumber numberWithInteger:90],[NSNumber numberWithInteger:93],[NSNumber numberWithInteger:100]];
    _slider.value = [_devInfo.rangeLimit floatValue];
    
    [_mixLabel setText:[NSString stringWithFormat:@"-%.2fdbm",[[NSNumber exchargeRange:_slider.value] floatValue]]];
    UIImage* image = [UIImage imageNamed:@"settings_off"];
    _cameraButton = [[UIBarButtonItem alloc]initWithImage:[image imageByScalingToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStylePlain target:self action:@selector(cameraButtonTouch:)];
    _dismissButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"丢失详情",nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonTouched)];
    self.navigationItem.rightBarButtonItems = @[_dismissButton,_cameraButton];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    if (_devInfo.connected) {
        [_cameraButton setEnabled:YES];
        _canCamera = YES;
    }else{
        [_cameraButton setEnabled:NO];
    }
    _canmeraOpen = NO;
}

-(void)tap:(UITapGestureRecognizer*)ge
{
    [_deviceNameLabel resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
     [[ConnectionManager sharedInstance]setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissButtonTouched
{
    [self performSegueWithIdentifier:@"disconnectDetail" sender:nil];
}
#pragma mark -camera

- (IBAction)cameraButtonTouch:(UIBarButtonItem *)sender {
    if (!_canCamera) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"设备未连接，无法使用遥控相机，请连接后使用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        
        if (_canmeraOpen) {
            _canmeraOpen = NO;
            UIImage* image = [UIImage imageNamed:@"settings_off"];
            
            [_cameraButton setImage:[image imageByScalingToSize:CGSizeMake(30, 30)]];
        }else{
            _canmeraOpen = YES;
            UIImage* image = [UIImage imageNamed:@"camera_enable"];
            
            [_cameraButton setImage:[image imageByScalingToSize:CGSizeMake(30, 30)]];//
        }
        return;
        
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
- (IBAction)sliderChange:(UISlider *)sender {
    NSLog(@"slider value Change");
    _devInfo.rangeLimit = [NSNumber numberWithFloat:sender.value];
    
    [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
    NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:[ConnectionManager sharedInstance].addedDeviceArray];
    [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
    [USER_DEFAULT synchronize];
    
    _devInfo.warningStrength = [NSNumber exchargeRange:sender.value];
    [_mixLabel setText:[NSString stringWithFormat:@"-%.2fdbm",[_devInfo.warningStrength floatValue]]];
    _canNotice = YES;
}
#pragma mark - viewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"disconnectDetail"])
    {
        mapViewController * secondViewController = (mapViewController *)segue.destinationViewController;
        secondViewController.devInfo = _devInfo;
    }
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
    if (device == _devInfo) {
        _devInfo.delegate = self;
    }
}

-(void)warningAction
{
    [[soundVibrateManager sharedInstance]playAlertSound];
    [[soundVibrateManager sharedInstance]vibrate];
}
- (void) didDisconnectWithDevice:(deviceInfo*)device
{
    _alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"您已失去与",nil), [NSString deviceNameWithDevice:device], NSLocalizedString(@"的连接",nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
    [_alert show];
    [_findButton setTitle:NSLocalizedString(@"失去连接",nil) forState:UIControlStateNormal];
    
    if (_warmingTimer) {
        return;
    }
    _warmingTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(warningAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_warmingTimer forMode:NSRunLoopCommonModes];
}
- (void) didConnectWithDevice:(deviceInfo*)device
{
    [_warmingTimer invalidate];
    _warmingTimer = nil;
    [_findButton setTitle:NSLocalizedString(@"找到我",nil) forState:UIControlStateNormal];
    
    UIImage* image = [UIImage imageNamed:@"camera"];
    [_cameraButton setImage:[image imageByScalingToSize:CGSizeMake(30, 40)]];
    _canCamera = YES;
}
- (void) didOutofRangWithDevice:(deviceInfo*)device
{
    if (_canNotice) {
        _canNotice = NO;
        _alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"已超出设定范围", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil)  otherButtonTitles:nil, nil];
        [_alertView show];
        [[soundVibrateManager sharedInstance]playAlertSound];
        [[soundVibrateManager sharedInstance]vibrate];
    }
}
- (void) didDeviceWanaFindMe:(deviceInfo*)device
{
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@想要找到你",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    [[soundVibrateManager sharedInstance]playAlertSound];
//    [[soundVibrateManager sharedInstance]vibrate];
    if (!_canmeraOpen) {
        if ([device isEqual:_devInfo]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"想要找到你", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
            [alert show];
            [[soundVibrateManager sharedInstance]playAlertSound];
            [[soundVibrateManager sharedInstance]vibrate];
            return;
        }
    }else{
        if (![device isEqual:_devInfo]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"想要找到你", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
            [alert show];
            [[soundVibrateManager sharedInstance]playAlertSound];
            [[soundVibrateManager sharedInstance]vibrate];
            return;
        }
        if (cameraVC) {
            [cameraVC takePicture];
        }else{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
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
    }
}
#pragma mark -devInfo

-(void)setDevInfo:(deviceInfo *)devsInfo
{
    if (devsInfo != _devInfo)
    {
        _devInfo = devsInfo;
        _devInfo.delegate = self;
    }
}

-(void)didUpdateData:(deviceInfo*)info
{
    if (_devInfo != info) {
        return;
    }
    _singalImageView.image = [info currentSignalStrengthImage];
    _batteryImageView.image = [info currentBatteryStrengthImage];
    CGFloat meter = (-1)*[info.signalStrength floatValue];
    
    if (meter < 30.0f) {
        meter = 31.0f;
    }else if(meter > 70.0f) {
        meter = 69.0f;
    }
    
    NSUInteger distance = ((meter -30)/40)*(_radarImagView.frame.size.width/2);
    [_searchView setMeterInt:distance];
}
- (IBAction)findButtonTouch:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"失去连接", nil) ]) {
        return;
    }
    
    if (_devInfo.connected) {
        if (_openl){
            _openl = NO;
            if ([[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl]) {
                [_findButton setTitle:NSLocalizedString(@"找到我",nil) forState:UIControlStateNormal];
                [_findButton setBackgroundImage:[UIImage imageNamed:@"ic_number_status_37.png"] forState:UIControlStateNormal];
                [_findButton setBackgroundImage:[UIImage imageNamed:@"ic_number_status_37.png"] forState:UIControlStateHighlighted];
            }
        }
        else{
            _openl = YES;
            if ([[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl]) {
                [_findButton setTitle:NSLocalizedString(@"安静",nil) forState:UIControlStateNormal];
                [_findButton setBackgroundImage:[UIImage imageNamed:@"ic_number_status_45.png"] forState:UIControlStateNormal];
                [_findButton setBackgroundImage:[UIImage imageNamed:@"ic_number_status_45.png"] forState:UIControlStateHighlighted];
            }
        }
        
        
    }else{
        
    }
    
}
#pragma mark - UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_warmingTimer invalidate];
    _warmingTimer = nil;
}
#pragma mark -UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [USER_DEFAULT removeObjectForKey:_devInfo.identifier];
    [USER_DEFAULT setObject:textField.text forKey:_devInfo.identifier];
    [USER_DEFAULT synchronize];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [USER_DEFAULT removeObjectForKey:_devInfo.identifier];
    [USER_DEFAULT setObject:textField.text forKey:_devInfo.identifier];
    [USER_DEFAULT synchronize];
    [_deviceNameLabel resignFirstResponder];
    return YES;
}

@end
