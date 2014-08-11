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
    self.rippleImageName = @"bg2.png";
    [super viewDidLoad];
    [_useDismissImageView setHidden:YES];
	// Do any additional setup after loading the view, typically from a nib.
    [_slider setThumbImage:[UIImage imageNamed:@"bar dot.png"] forState:UIControlStateNormal];
    
    _deviceNameLabel.text = [NSString deviceNameWithDevice:_devInfo];
    _deviceNameLabel.delegate = self;
   
    
//    if (_devInfo.connected) {
//        [_findButton setTitle:NSLocalizedString(@"找到我",nil) forState:UIControlStateNormal];
//    }else{
//        [_findButton setTitle:NSLocalizedString(@"连接",nil) forState:UIControlStateNormal];
//    }
    _openl  = NO;
    _canNotice = YES;
    _canCamera = NO;
    
    _areaIndexArray = @[[NSNumber numberWithInteger:40],[NSNumber numberWithInteger:80],[NSNumber numberWithInteger:90],[NSNumber numberWithInteger:93],[NSNumber numberWithInteger:100]];
    _slider.value = [_devInfo.rangeLimit floatValue];
    
   
    _canmeraOpen = NO;
    
    
    UIPanGestureRecognizer  *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.enabled = YES;
    panGestureRecognizer.cancelsTouchesInView = NO;
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer  *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    singleTapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    [_slider setThumbImage:[UIImage imageNamed:@"iseek2_03"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"iseek2_05"] forState:UIControlStateNormal];
    
    [_slider setMinimumTrackImage:[UIImage imageNamed:@"iseek2_10"] forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:[UIImage imageNamed:@"iseek2_18"] forState:UIControlStateNormal];
    
    [_switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    _switchView.offImage = [UIImage imageNamed:@"lingsheng2"];
    _switchView.onImage = [UIImage imageNamed:@"paizhao2"];
    _switchView.onColor = [UIColor getColor:@"1688c4"];
    _switchView.isRounded = YES;
    
    _timerWater = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(waterRandom) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timerWater forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewfoceUnload) name:NSNotificationCenter_appWillEnterBackGround object:nil];
}
-(void)waterRandom
{
    int width = DEVICE_WIDTH;
    int height = DEVICE_HEIGHT;
    int x = arc4random()%width;
    int y = arc4random()%height;
    CGPoint randomPoint = CGPointMake(x, y);
    [_ripple initiateRippleAtLocation:randomPoint];
}
-(void)switchChanged:(SevenSwitch*)sender
{
        _canmeraOpen = sender.on;
}
- (void)handlePanGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:nil];
    [_ripple initiateRippleAtLocation:location];
    [_deviceNameLabel resignFirstResponder];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self cleanRipple];
    stopUdpate = NO;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    stopUdpate = YES;
//    [self cleanRipple];
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
    _canNotice = YES;
}
#pragma mark - viewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"dismissDetailIdentifier"])
    {
        dimissDetailTableViewController * _dimissDetailTableViewController = (dimissDetailTableViewController *)segue.destinationViewController;
        _dimissDetailTableViewController.devInfo = _devInfo;
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
    [[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:YES];
}
- (void) didDisconnectWithDevice:(deviceInfo*)device
{
    _alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"您已失去与",nil), [NSString deviceNameWithDevice:device], NSLocalizedString(@"的连接",nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
    [_alert show];
    
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
}
- (void) didOutofRangWithDevice:(deviceInfo*)device
{
    if (_canNotice) {
        _canNotice = NO;
        _alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"已超出设定范围", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil)  otherButtonTitles:nil, nil];
        [_alertView show];
        [[soundVibrateManager sharedInstance]playAlertSound];
        [[soundVibrateManager sharedInstance]vibrate];
        [[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl];
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

- (IBAction)backButtonTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self viewfoceUnload];
}

- (IBAction)editButtonTouch:(UIButton *)sender {
    [_deviceNameLabel becomeFirstResponder];
}

-(void)didUpdateData:(deviceInfo*)info
{
    if (_devInfo != info) {
        return;
    }
    _batteryLabel.text = [NSString stringWithFormat:@"%.f%%",info.batteryLevel.floatValue];
    _singalImageView.image = [info currentSignalStrengthImage];
    _batteryImageView.image = [info currentBatteryStrengthImage];
    CGFloat meter = (-1)*[info.signalStrength floatValue];
    
    if (meter < 30.0f) {
        meter = 30.0f;
    }else if(meter > 70.0f) {
        meter = 70.0f;
    }
    
    CGFloat distance = meter/70.0f;
    NSLog(@"distance:%f,%f",distance,distance);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _radarImagView.transform = CGAffineTransformScale(CGAffineTransformIdentity, distance, distance);
    [UIView commitAnimations];
}
- (IBAction)findButtonTouch:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"失去连接", nil) ]) {
        return;
    }
    
    if (_devInfo.connected) {
        [[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:YES];
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
