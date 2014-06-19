//
//  SecondViewController.h
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchRadarView.h"
#import "deviceInfo.h"
#import "GlobalHeader.h"
#import "mapViewController.h"

@interface SecondViewController : UIViewController<deviceInfoDelegate,ConnectionManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    searchRadarView* _searchView;
    BOOL _openl;
    UIAlertView* _alertView;
    
    BOOL _canNotice;
    
    NSArray* _areaIndexArray;
    
    UIImagePickerController* cameraVC;
}
@property (weak, nonatomic) IBOutlet UIImageView *radarImagView;

@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)sliderChange:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *batteryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *singalImageView;

@property (weak, nonatomic) IBOutlet UIButton *findButton;
@property (weak, nonatomic) IBOutlet UILabel *mixLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;



- (IBAction)findButtonTouch:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedView;

- (IBAction)alarmSegmentControlValueChanged:(UISegmentedControl *)sender;


@property (strong, nonatomic) deviceInfo *devInfo;
-(void)setDevInfo:(deviceInfo *)devsInfo;
@end
