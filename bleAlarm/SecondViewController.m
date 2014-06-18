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
    
    _deviceNameLabel.text = _devInfo.idString;
    
    [[ConnectionManager sharedInstance]setDelegate:self];
    
    if (_devInfo.connected) {
        [_findButton setTitle:@"FIND ME" forState:UIControlStateNormal];
    }else{
        [_findButton setTitle:@"CONNECT" forState:UIControlStateNormal];
    }
    _slider.value = [_devInfo.warningStrength floatValue];
    _openl  = NO;
    _canNotice = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sliderChange:(UISlider *)sender {
    NSLog(@"slider value Change");
    _devInfo.warningStrength = [NSNumber numberWithFloat:sender.value];
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
- (void) didDisconnectWithDevice:(deviceInfo*)device
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"您已失去与%@的连接",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [_findButton setTitle:@"失去连接" forState:UIControlStateNormal];
    [[soundVibrateManager sharedInstance]playAlertSound];
    [[soundVibrateManager sharedInstance]vibrate];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:YES];
        [self presentViewController:cameraVC animated:YES completion:nil];
    }
}
- (void) didConnectWithDevice:(deviceInfo*)device
{
    [_findButton setTitle:@"FIND ME" forState:UIControlStateNormal];
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
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"%@想要找到你",device.idString] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [[soundVibrateManager sharedInstance]playAlertSound];
    [[soundVibrateManager sharedInstance]vibrate];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:YES];
        [self presentViewController:cameraVC animated:YES completion:nil];
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
    NSLog(@"signalStrength:%f",[info.signalStrength floatValue]);
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
                [_findButton setTitle:@"FIND ME" forState:UIControlStateNormal];
            }
        }
        else{
            _openl = YES;
            if ([[ConnectionManager sharedInstance]findDevice:_devInfo.identifier isOn:_openl]) {
                [_findButton setTitle:@"SILENCE TAG" forState:UIControlStateNormal];
            }
        }
        
        
    }
    
}


@end
