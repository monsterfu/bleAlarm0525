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
    
    if([USER_DEFAULT objectForKey:_devInfo.identifier])
    {
        _deviceNameLabel.text = [USER_DEFAULT objectForKey:_devInfo.identifier];
    }else{
        _deviceNameLabel.text = _devInfo.idString;
    }
    _deviceNameLabel.delegate = self;
   
    
    if (_devInfo.connected) {
        [_findButton setTitle:@"找到我" forState:UIControlStateNormal];
    }else{
        [_findButton setTitle:@"连接" forState:UIControlStateNormal];
    }
    _openl  = NO;
    _canNotice = YES;
    _canCamera = NO;
    
    _areaIndexArray = @[[NSNumber numberWithInteger:40],[NSNumber numberWithInteger:80],[NSNumber numberWithInteger:90],[NSNumber numberWithInteger:93],[NSNumber numberWithInteger:100]];
    _slider.value = 100.0f;
    [_mixLabel setText:[NSString stringWithFormat:@"-%ddbm",100]];
    UIImage* image = [UIImage imageNamed:@"xx"];
    _cameraButton = [[UIBarButtonItem alloc]initWithImage:[image imageByScalingToSize:CGSizeMake(30, 30)] style:UIBarButtonItemStylePlain target:self action:@selector(cameraButtonTouch:)];
    _dismissButton = [[UIBarButtonItem alloc]initWithTitle:@"丢失详情" style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonTouched)];
    self.navigationItem.rightBarButtonItems = @[_dismissButton,_cameraButton];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    if (_devInfo.connected) {
        UIImage* image = [UIImage imageNamed:@"camera"];
        [_cameraButton setImage:[image imageByScalingToSize:CGSizeMake(30, 40)]];
        _canCamera = YES;
    }
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
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            cameraVC = [[UIImagePickerController alloc] init];
            [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
            [cameraVC setDelegate:self];
            [cameraVC setAllowsEditing:YES];
            [self presentViewController:cameraVC animated:YES completion:nil];
        }
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
    
    if (0 <= sender.value&& sender.value <= 25) {
        _devInfo.warningStrength = [NSNumber numberWithFloat:40.0f+(40.0f/25.0f)*sender.value];
    }else if (25 < sender.value&& sender.value <= 50){
        _devInfo.warningStrength = [NSNumber numberWithFloat:80.0f+(10.0f/25.0f)*(sender.value - 25)];
    }else if (50 < sender.value&& sender.value <= 75){
        _devInfo.warningStrength = [NSNumber numberWithFloat:90.0f+(3.0f/25.0f)*(sender.value - 50)];
    }else if (75 < sender.value&& sender.value <= 100){
        _devInfo.warningStrength = [NSNumber numberWithFloat:93.0f+(7.0f/25.0f)*(sender.value - 75)];
    }
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
    _alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"您已失去与%@的连接",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [_alert show];
    [_findButton setTitle:@"失去连接" forState:UIControlStateNormal];
    
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
    [_findButton setTitle:@"找到我" forState:UIControlStateNormal];
    
    UIImage* image = [UIImage imageNamed:@"camera"];
    [_cameraButton setImage:[image imageByScalingToSize:CGSizeMake(30, 40)]];
    _canCamera = YES;
}
- (void) didOutofRangWithDevice:(deviceInfo*)device
{
    if (_canNotice) {
        _canNotice = NO;
        _alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@已超出设定范围",device.idString] delegate:self cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
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
    
    if (![device isEqual:_devInfo]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@想要找到你",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [[soundVibrateManager sharedInstance]playAlertSound];
        [[soundVibrateManager sharedInstance]vibrate];
        return;
    }
    
    if (cameraVC) {
        [cameraVC takePicture];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@想要找到你",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [[soundVibrateManager sharedInstance]playAlertSound];
        [[soundVibrateManager sharedInstance]vibrate];
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
    
    if ([sender.titleLabel.text isEqualToString:@"失去连接"]) {
        return;
    }
    
    if (_devInfo.connected) {
        if (_openl){
            _openl = NO;
            if ([[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl]) {
                [_findButton setTitle:@"找到我" forState:UIControlStateNormal];
                [_findButton setBackgroundImage:[UIImage imageNamed:@"ic_number_status_37.png"] forState:UIControlStateNormal];
                [_findButton setBackgroundImage:[UIImage imageNamed:@"ic_number_status_37.png"] forState:UIControlStateHighlighted];
            }
        }
        else{
            _openl = YES;
            if ([[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl]) {
                [_findButton setTitle:@"安静" forState:UIControlStateNormal];
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
