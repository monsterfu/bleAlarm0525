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
    
    _isLightOn = NO;
    
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
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    [cameraVC dismissViewControllerAnimated:YES completion:nil];
//    cameraVC = nil;
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
-(void)warningAction1
{
    [[soundVibrateManager sharedInstance]playAlertSound];
    [[soundVibrateManager sharedInstance]vibrate];
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
    if (_alert) {
        [_alert dismissWithClickedButtonIndex:0 animated:YES];
        _alert = nil;
    }
    [_warmingTimer invalidate];
    _warmingTimer = nil;
}
- (void) didOutofRangWithDevice:(deviceInfo*)device on:(BOOL)on
{
    if (1){//_canNotice) {
        _canNotice = NO;
        if (!on) {
            [_warmingTimer invalidate];
            [_alertView dismissWithClickedButtonIndex:0 animated:YES];
            _alertView = nil;
        }else{
            _alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"已超出设定范围", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil)  otherButtonTitles:nil, nil];
            [_alertView show];
            [[soundVibrateManager sharedInstance]playAlertSound];
            [[soundVibrateManager sharedInstance]vibrate];
            [[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl];
            _warmingTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(warningAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:_warmingTimer forMode:NSRunLoopCommonModes];
        }
    }
}
- (void) didDeviceWanaFindMe:(deviceInfo*)device on:(BOOL)on
{
//    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@想要找到你",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    [[soundVibrateManager sharedInstance]playAlertSound];
//    [[soundVibrateManager sharedInstance]vibrate];
    
    if (_findPhoneAlert == nil) {
        on = YES;
    }else{
        on = NO;
    }
    if (!_canmeraOpen) {
        if ([device isEqual:_devInfo]) {
            if (on) {
                _findPhoneAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"想要找到你", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
                [_findPhoneAlert show];
                [[soundVibrateManager sharedInstance]playAlertSound];
                [[soundVibrateManager sharedInstance]vibrate];
                _warmingTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(warningAction1) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:_warmingTimer forMode:NSRunLoopCommonModes];
            }else{
                [_findPhoneAlert dismissWithClickedButtonIndex:0 animated:YES];
                [_warmingTimer invalidate];
                _findPhoneAlert = nil;
            }
            return;
        }
    }else{
        if (![device isEqual:_devInfo]) {
            if (on) {
                _findPhoneAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:[NSString stringWithFormat:@"%@%@",[NSString deviceNameWithDevice:device],NSLocalizedString(@"想要找到你", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
                [_findPhoneAlert show];
                [[soundVibrateManager sharedInstance]playAlertSound];
                [[soundVibrateManager sharedInstance]vibrate];
                _warmingTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(warningAction1) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:_warmingTimer forMode:NSRunLoopCommonModes];
            }else{
                [_findPhoneAlert dismissWithClickedButtonIndex:0 animated:YES];
                [_warmingTimer invalidate];
                _findPhoneAlert = nil;
            }
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
                [cameraVC setAllowsEditing:NO];
                [cameraVC setShowsCameraControls:NO];
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
    
//    if (0 <= value&& value <= 25) {
//        return [NSNumber numberWithFloat:40.0f+(40.0f/25.0f)*value];
//    }else if (25 < value&& value <= 50){
//        return[NSNumber numberWithFloat:80.0f+(10.0f/25.0f)*(value - 25)];
//    }else if (50 < value&& value <= 75){
//        return[NSNumber numberWithFloat:90.0f+(3.0f/25.0f)*(value - 50)];
//    }else if (75 < value&& value <= 100){
//        return[NSNumber numberWithFloat:93.0f+(7.0f/25.0f)*(value - 75)];
//    }
    CGFloat distance = meter/100.0f;
    if (meter <= 40.0f) {
        distance = 0.1f + 0.15f*(meter)/40.0f;
    }else if(40.0f < meter&& meter <= 80.0f) {
        distance = 0.25f + 0.25f*(meter-40.0f)/40.0f;
    }else if(80.0f < meter&& meter <= 90.0f) {
        distance = 0.5f + 0.25f*(meter-80.0f)/10.0f;
    }else if(90.0f < meter&& meter <= 93.0f) {
        distance = 0.25f + 0.25f*(meter-90.0f)/3.0f;
    }else if(93.0f < meter&& meter <= 100.0f) {
        distance = 0.75f + 0.25f*(meter-93.0f)/7.0f;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
    _radarImagView.transform = CGAffineTransformScale(CGAffineTransformIdentity, distance, distance);
    [UIView commitAnimations];
}
- (IBAction)findButtonTouch:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"失去连接", nil) ]) {
        return;
    }
    if (_openl) {
        _openl = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek1 (19)"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek1 (18)"] forState:UIControlStateHighlighted];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek1 (18)"] forState:UIControlStateSelected];
    }else{
        _openl = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek12 (2)"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek12 (1)"] forState:UIControlStateHighlighted];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek12 (1)"] forState:UIControlStateSelected];
    }
    if (_devInfo.connected) {
        [[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl];
    }else{
        
    }
    
}
#pragma mark - UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _canNotice = YES;
    [_warmingTimer invalidate];
    _warmingTimer = nil;
    _findPhoneAlert = nil;
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
#pragma mark - captureLight
-(void)captureLightOn:(BOOL)on
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (on) {
            [device setTorchMode: AVCaptureTorchModeOn];
        }
        else
        {
            [device setTorchMode: AVCaptureTorchModeOff];
        }
        
        [device unlockForConfiguration];
    }
}
- (IBAction)captureLightButtonTouch:(UIButton *)sender {
    if (_isLightOn) {
        _isLightOn = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek13 (3)"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek13 (4)"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek13 (4)"] forState:UIControlStateNormal];
    }else{
        _isLightOn = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek13 (2)"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek13 (1)"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"iseek13 (1)"] forState:UIControlStateNormal];
    }
    [self captureLightOn:_isLightOn];
}
@end
