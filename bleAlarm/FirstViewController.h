//
//  FirstViewController.h
//  bleAlarm
//
//  Created by Monster on 14-4-18.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "findTableViewCell.h"
#import "GlobalHeader.h"
#import "addedDeviceTableViewCell.h"
#import "newDeviceTableViewCell.h"
#import "SecondViewController.h"

@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ConnectionManagerDelegate,deviceInfoDelegate,addedDeviceTableViewCellDelegate,newDeviceTableViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray* rImgArray;
    NSArray* lImgArray;
    
    NSTimer* searchAnimationTimer;
    NSMutableArray* addedDeviceArray;
    NSMutableArray* newDeviceArray;
    
    addedDeviceTableViewCell* addedCell;
    newDeviceTableViewCell* newCell;
    
    UIImagePickerController *cameraVC;
    
    BOOL _searchOpen;
}

@property (strong, nonatomic) deviceInfo *devInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *singelr1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singelr2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singelr3ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singelr4ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singelr5ImgView;

@property (weak, nonatomic) IBOutlet UIImageView *singell1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singell2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singell3ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singell4ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *singell5ImgView;

@property (nonatomic, retain)NSMutableArray* devicesArray;

- (IBAction)searchButtonTouched:(UIButton *)sender;

- (IBAction)cameraButtonTouch:(UIBarButtonItem *)sender;

@end
