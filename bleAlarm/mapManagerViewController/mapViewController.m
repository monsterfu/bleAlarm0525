//
//  mapViewController.m
//  bleAlarm
//
//  Created by Monster on 14-5-22.
//  Copyright (c) 2014年 HYQ. All rights reserved.
//

#import "mapViewController.h"
#import "GlobalHeader.h"

@interface mapViewController ()

@end

@implementation mapViewController

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
    
    _mapView.delegate = self;
    for (deviceDisconnectInfo* info in [_devInfo locationCoordArray]) {
        
        NSString* title = [info.date description];
        
        CLLocation* _location = [[CLLocation alloc]initWithLatitude:info.locationCoordinate2D.latitude longitude:info.locationCoordinate2D.longitude];
        CLLocation* _newLocation = [_location locationMarsFromEarth];
        
        [self createAnnotationWithCoords:_newLocation.coordinate title:[NSString deviceNameWithDevice:_devInfo] subtitle:title];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords title:(NSString*)title subtitle:(NSString*)subtitle {
    recordAnnotation *annotation = [[recordAnnotation alloc] initWithCoordinate:
                                    coords];
    annotation.title = title;
    annotation.subtitle = subtitle;
    [_mapView addAnnotation:annotation];
    
    
    //    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    //    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    //    NSLog(@"Lat: %@  Lng: %@", strLat, strLng);
    
    //    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    float zoomLevel = 0.02;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords,MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
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
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotation.image = [UIImage imageNamed:@"zhen.png"];
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}


- (IBAction)backButtonTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
