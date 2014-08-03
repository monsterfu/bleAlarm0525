//
//  mapViewController.h
//  bleAlarm
//
//  Created by Monster on 14-5-22.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "recordAnnotation.h"
#import "deviceInfo.h"
#import "deviceDisconnectInfo.h"
#import "deviceDisconnectInfo.h"

@interface mapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) deviceInfo *devInfo;

- (IBAction)backButtonTouch:(UIButton *)sender;


@end
