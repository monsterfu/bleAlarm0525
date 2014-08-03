//
//  dimissDetailTableViewController.m
//  bleAlarm
//
//  Created by 符鑫 on 14-8-3.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "dimissDetailTableViewController.h"

@interface dimissDetailTableViewController ()

@end

@implementation dimissDetailTableViewController

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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView* viewBg = [UIView new];
    viewBg.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:viewBg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"disconnectDetail"])
    {
        mapViewController * secondViewController = (mapViewController *)segue.destinationViewController;
        secondViewController.devInfo = _devInfo;
    }
}


- (IBAction)backButtonTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_devInfo.locationCoordArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    cell.backgroundColor = [UIColor clearColor];
    deviceDisconnectInfo* info = (deviceDisconnectInfo*)[_devInfo.locationCoordArray objectAtIndex:indexPath.row];
    
    NSLocale *cnTime = [[NSLocale alloc]initWithLocaleIdentifier:[[USER_DEFAULT objectForKey:@"AppleLanguages"]objectAtIndex:0]];
    
    NSString* dateStr = [[info.date descriptionWithLocale:cnTime]substringToIndex:10];
    
    cell.textLabel.text = dateStr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"disconnectDetail" sender:nil];
}
@end
