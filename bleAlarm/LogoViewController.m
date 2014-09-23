//
//  LogoViewController.m
//  bleAlarm
//
//  Created by Monster on 14-9-23.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "LogoViewController.h"

@interface LogoViewController ()

@end

@implementation LogoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _urlArray = @[@"http://www.dialog-semiconductor.com",@"http://www.honestar.com",@"http://www.sbote.com",@"http://www.skynoon.com",@"http://www.skynoon.com"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonTouched:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)url1ButtonTouched:(UIButton *)sender {
    NSURL* url = [NSURL URLWithString:[_urlArray objectAtIndex:0]];
    
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)url2ButtonTouched:(UIButton *)sender {
    NSURL* url = [NSURL URLWithString:[_urlArray objectAtIndex:1]];
    
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)url3ButtonTouched:(UIButton *)sender {
    NSURL* url = [NSURL URLWithString:[_urlArray objectAtIndex:2]];
    
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)url4ButtonTouched:(UIButton *)sender {
    NSURL* url = [NSURL URLWithString:[_urlArray objectAtIndex:3]];
    
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)url5ButtonTouched:(UIButton *)sender {
    NSURL* url = [NSURL URLWithString:[_urlArray objectAtIndex:4]];
    
    [[UIApplication sharedApplication]openURL:url];
}
@end
