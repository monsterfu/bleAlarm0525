//
//  LogoViewController.h
//  bleAlarm
//
//  Created by Monster on 14-9-23.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoViewController : UIViewController
{
    NSArray* _urlArray;
}

- (IBAction)backButtonTouched:(UIButton *)sender;

- (IBAction)url1ButtonTouched:(UIButton *)sender;
- (IBAction)url2ButtonTouched:(UIButton *)sender;
- (IBAction)url3ButtonTouched:(UIButton *)sender;
- (IBAction)url4ButtonTouched:(UIButton *)sender;
- (IBAction)url5ButtonTouched:(UIButton *)sender;



@end
